module PredictsController

using Genie.Renderer.Json, Genie.Requests
using Lux, JLD2

include(joinpath(ENV["ROOT_PARENT"], ENV["EXTERNAL_LYRA_UTILS_PATH"], "ColorOKLab.jl"))

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
  # Get hex from URL query, e.g. /predict?hex=17BA11
  # Or from JSON body: jsonpayload()["hex"]
  input_hex = getpayload(:hex, "#17BA11") 
  
  if !startswith(input_hex, "#")
      input_hex = "#" * input_hex
  end

  try
      x = hex_to_oklab_vec(input_hex)
      x_matrix = reshape(x, :, 1) # (3, 1)

      # AI Predict (output is OFFSET)
      y_offset, _ = Lux.apply(tstate.model, x_matrix, tstate.parameters, tstate.states)

      # ADD BACK main color
      y_pred = y_offset .+ repeat(x_matrix, 9)

      # broken down into 9 colors (3 sets of gradients × 3 colors)
      colors_vec = reshape(vec(y_pred), 3, 9)
      
      results = [oklab_to_hex(colors_vec[:, i]) for i in 1:9]

      return json(Dict(
          "status" => "success",
          "input" => input_hex,
          "palette" => results
      ))
  catch e
      return json(Dict("status" => "error", "message" => string(e)), 500)
  end
end

end
