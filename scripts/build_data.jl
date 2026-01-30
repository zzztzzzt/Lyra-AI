using JLD2

using LyraUtils.ColorOKLab
using LyraUtils.PaletteAugment

const OKLAB_DIM = 3
const PALETTE_SIZE = 9
const AUGMENT_STEPS = 5

const L_DARK_THRESHOLD   = 0.50f0
const L_BRIGHT_THRESHOLD = 0.80f0

# 1. Tool Functions

#=
Input：[cMAIN, c1_start, c1_end, c2_start, c2_end, c3_start, c3_end]
Auto calculate mid-color between c_start and c_end
Output：[c1_start, c1_mid, c1_end, c2_start, c2_mid, c2_end, c3_start, c3_mid, c3_end]
=#
function convert_pairs_to_gradients(hex_list::Vector{<:AbstractString})
    if length(hex_list) != 7
        error("Expected 7 colors (main + 3 pairs), got $(length(hex_list))")
    end
    
    main_v = hex_to_oklab_vec(hex_list[1])
    gradient_colors = Vector{Vector{Float32}}()
    
    # process 3 color pair
    for i in 1:3
        start_hex = hex_list[2*i] # index 2,4,6
        end_hex = hex_list[2*i + 1] # index 3,5,7
        
        start_v = hex_to_oklab_vec(start_hex)
        end_v = hex_to_oklab_vec(end_hex)
        
        # Auto calculate mid-color (50% linear interpolation)
        mid_v = 0.5f0 .* start_v .+ 0.5f0 .* end_v
        
        push!(gradient_colors, start_v)
        push!(gradient_colors, mid_v)
        push!(gradient_colors, end_v)
    end
    
    return main_v, gradient_colors
end

#=
fill in the required number of colors to the specified palette_size.
If insufficient, use the primary color to fill in the remaining colors to maintain consistent data shape.
=#
function normalize_palette!(
    others_v::Vector{Vector{Float32}},
    main_v::Vector{Float32},
    palette_size::Int
)
    while length(others_v) < palette_size
        push!(others_v, main_v)
    end
    return others_v
end

# 2. Primary API

#=
change Hex to OKLab, and save the augmented data to a JLD2 dataset

Dataset format:
- X : 3 × N (main color OKLab)
- Y : 27 × N (9 colors OKLab: 3 gradient sets)
=#
function save_augmented_palette(
    filename::AbstractString,
    hex_list::Vector{<:AbstractString};
    palette_size::Int = PALETTE_SIZE,
    aug_steps::Int = AUGMENT_STEPS
)
    # Ensure the directory exists
    dir = dirname(filename)
    if !isempty(dir) && !isdir(dir)
        mkpath(dir)
        println("Created directory: $dir")
    end

    # load the dataset from the file if it exists, otherwise initialize an empty dataset
    if isfile(filename)
        @load filename X_total Y_total
    else
        X_total = Matrix{Float32}(undef, OKLAB_DIM, 0)
        Y_total = Matrix{Float32}(undef, OKLAB_DIM * palette_size, 0)
    end

    main_v, others_v = convert_pairs_to_gradients(hex_list)
    
    normalize_palette!(others_v, main_v, palette_size)

    main_lightness = main_v[1] # L value in OKLab

    l_scale_range = if main_lightness < L_DARK_THRESHOLD
        (1.00f0, 1.15f0) # only brighten it
    elseif main_lightness > L_BRIGHT_THRESHOLD
        (0.85f0, 1.00f0) # only darken it
    else
        (0.85f0, 1.15f0) # normal range
    end

    # Brightness / Lightness augmentation
    for scale in range(l_scale_range[1], l_scale_range[2], length=aug_steps)
        aug_x, aug_y = augment_sample_brightness(main_v, others_v, Float32(scale))
        X_total = hcat(X_total, aug_x)
        Y_total = hcat(Y_total, aug_y)
    end

    @save filename X_total Y_total

    println("palette augmentation completed")
    println("Saved to: $filename")
    println("total samples: ", size(X_total, 2))
end

function prompt_palette(n::Int)
    while true
        println("Paste all hex colors at once? (y/n)")
        print("> ")
        mode = lowercase(strip(readline()))

        if mode == "y"
            println("Paste exactly $n hex colors (space or comma separated):")
            print("> ")
            line = readline()

            hexes = split(line, r"[,\s]+"; keepempty=false)
            hexes = String.(hexes) # SubString → String
            hexes = replace.(hexes, "\"" => "", "'" => "")

            if length(hexes) != n
                println("Error: You must provide exactly $n hex colors, but got $(length(hexes)).")
                println("Please try again.\n")
                continue
            end

            return hexes

        elseif mode == "n"
            hexes = String[]
            for i in 1:n
                print("please enter $i / $n Hex color: ")
                input = strip(readline())
                clean_hex = replace(input, ('"' => ""), ("'" => ""))
                push!(hexes, clean_hex)
            end
            return hexes

        else
            println("Invalid input. Please enter 'y' or 'n'.\n")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    hex_list = prompt_palette(7)
    save_augmented_palette("training_data/color_data.jld2", hex_list)
end

# Example Usage ( Demonstration purposes only. For formal training, please use our GUI or Batch Training )
#=
my_palette = [
    "#ABE7FF", # main color
    "#DAF0F9", "#F4F9FF",  # gradient 1
    "#425573", "#CCCCCC",  # gradient 2
    "#8C939F", "#D6EFFF"   # gradient 3
]

save_augmented_palette("../training_data/color_data.jld2", my_palette)
=#