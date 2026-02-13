module PredictsController

using Genie.Renderer.Json, Genie.Requests
using Lux, JLD2

using LyraUtils.ColorOKLab

const BOLDNESS_MIN = 1.0f0
const BOLDNESS_MAX = 1.25f0

# After obtaining the path from ENV, check if the file exists
const model_path = begin
    p1 = joinpath(ENV["ROOT_PARENT"], ENV["EXTERNAL_CUSTOM_AI_MODEL_PATH"])
    if !isempty(p1) && isfile(p1)
        p1
    else
        p2 = joinpath(ENV["ROOT_PARENT"], ENV["EXTERNAL_NEWEST_LYRA_MODEL_PATH"])
        if !isempty(p2) && isfile(p2)
            p2
        else
            error("Error : The model file path does not exist. Please check CUSTOM_AI_MODEL_PATH & NEWEST_LYRA_MODEL_PATH in ENV")
        end
    end
end

@load model_path tstate

# Public API entrypoint
function generate()
    # Supports 2 Modes : 
    # - OKLCH：/api/predict?oklch=0.7,0.1,120 , OR body: { "oklch": [0.7, 0.1, 120] }
    # - Hex：/api/predict?hex=17BA11 , OR body: { "hex": "#17BA11" }

    raw_oklch = getpayload(:oklch, nothing)
    raw_hex   = getpayload(:hex, nothing)

    boldness = rand(Float32) * (BOLDNESS_MAX - BOLDNESS_MIN) + BOLDNESS_MIN

    # 1) If oklch is provided, then oklch will be main
    if raw_oklch !== nothing
        # Normalize oklch input to a 3-element Float32 vector [L, C, h]
        oklch_vec = try
            if raw_oklch isa AbstractVector && length(raw_oklch) == 3
                Float32.(raw_oklch)
            elseif raw_oklch isa String
                parts = split(raw_oklch, [',', ' '])
                parts = filter(!isempty, parts)
                if length(parts) != 3
                    error("Expected 3 components for OKLCH, got $(length(parts))")
                end
                Float32.(parse.(Float64, parts))
            else
                error("Unsupported 'oklch' format: $(typeof(raw_oklch))")
            end
        catch e
            return json(Dict(
                "status" => "error",
                "message" => "Failed to parse 'oklch'"
                # For Debug
                #"message" => "Failed to parse 'oklch': $(e)"
            ), 400)
        end

        try
            # Convert OKLCH -> OKLab for the model
            x = oklch_to_oklab_vec(oklch_vec)
            x_matrix = reshape(x, :, 1) # (3, 1)

            # AI Predict (output is OFFSET)
            y_offset, _ = Lux.apply(tstate.model, x_matrix, tstate.parameters, tstate.states)

            # ADD BACK main color
            y_pred = (boldness .* y_offset) .+ repeat(x_matrix, 9)

            # broken down into 9 colors (3 sets of gradients × 3 colors)
            colors_vec = reshape(vec(y_pred), 3, 9)

            # Convert each OKLab color to both OKLCH & Hex
            palette_oklch = [oklab_to_oklch_vec(colors_vec[:, i]) for i in 1:9]
            palette_hex = [oklab_to_hex(colors_vec[:, i]) for i in 1:9]

            return json(Dict(
                "status"         => "success",
                "mode"           => "oklch",
                "boldness"       => boldness,
                "input_oklch"    => oklch_vec,
                "palette_oklch"  => palette_oklch,
                "palette_hex"    => palette_hex
            ))
        catch e
            return json(Dict("status" => "error", "message" => "An error happened when using OKLCH Mode in PredictsController"), 500)
            # For Debug
            #return json(Dict("status" => "error", "message" => string(e)), 500)
        end
    end

    # 2) If no oklch but hex, hex will be main
    if raw_hex !== nothing
        input_hex = String(raw_hex)
        if !startswith(input_hex, "#")
            input_hex = "#" * input_hex
        end

        try
            x = hex_to_oklab_vec(input_hex)
            x_matrix = reshape(x, :, 1) # (3, 1)

            # AI Predict (output is OFFSET)
            y_offset, _ = Lux.apply(tstate.model, x_matrix, tstate.parameters, tstate.states)

            # ADD BACK main color
            y_pred = (boldness .* y_offset) .+ repeat(x_matrix, 9)

            # broken down into 9 colors (3 sets of gradients × 3 colors)
            colors_vec = reshape(vec(y_pred), 3, 9)
            
            results_hex = [oklab_to_hex(colors_vec[:, i]) for i in 1:9]
            results_oklch = [oklab_to_oklch_vec(colors_vec[:, i]) for i in 1:9]

            return json(Dict(
                "status"        => "success",
                "mode"          => "hex",
                "boldness"      => boldness,
                "input_hex"     => input_hex,
                "palette"       => results_hex,
                "palette_oklch" => results_oklch
            ))
        catch e
            return json(Dict("status" => "error", "message" => "An error happened when using Hex Mode in PredictsController"), 500)
            # For Debug
            #return json(Dict("status" => "error", "message" => string(e)), 500)
        end
    end

    # 3) Both oklch & hex not provided
    return json(Dict(
        "status"  => "error",
        "message" => "Missing color input. Provide either 'hex' or 'oklch'."
    ), 400)
end

end
