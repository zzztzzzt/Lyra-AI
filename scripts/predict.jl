using Lux, JLD2
include("../src/lyra_utils/ColorOKLab.jl")

# 1. Load Model
@load "models/trained_color_model.jld2" tstate

# 2. Inference function
function Lyra_generate_palette(input_hex::String)
    x = hex_to_oklab_vec(input_hex)
    x_matrix = reshape(x, :, 1) # (3, 1)
    
    # AI Predict
    y_pred, _ = Lux.apply(tstate.model, x_matrix, tstate.parameters, tstate.states)
    
    # broken down into 9 colors (3 sets of gradients × 3 colors)
    colors_vec = reshape(vec(y_pred), 3, 9)
    
    println("⭐ ||||||  Lyra already got the color ( Input : $input_hex )  |||||| ⭐")
    for i in 1:9
        c_hex = oklab_to_hex(colors_vec[:, i])
        println("Color $i: $c_hex")
    end
end

# Test
Lyra_generate_palette("#CA38FF")