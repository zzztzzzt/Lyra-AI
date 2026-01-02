using JLD2
include("ColorOKLab.jl")

const OKLAB_DIM = 3
const PALETTE_SIZE = 6
const AUGMENT_STEPS = 10
const L_SHIFT_RANGE = (-0.1f0, 0.1f0)

# 1. Tool Functions

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

# generate an augmentation sample based on the brightness offset.
function augment_sample(
    main_v::Vector{Float32},
    others_v::Vector{Vector{Float32}},
    l_shift::Float32
)
    # main color
    aug_x = copy(main_v)
    aug_x[1] = clamp(aug_x[1] + l_shift, 0.0f0, 1.0f0)

    # other colors
    aug_y = Float32[]
    for v in others_v
        v_new = copy(v)
        v_new[1] = clamp(v_new[1] + l_shift, 0.0f0, 1.0f0)
        append!(aug_y, v_new)
    end

    return aug_x, aug_y
end

# 2. Primary API

#=
change Hex to OKLab, and save the augmented data to a BSON dataset

Dataset format:
- X : 3 × N (main color OKLab)
- Y : 18 × N (other 6 colors OKLab)
=#
function save_augmented_palette(
    filename::AbstractString,
    hex_list::Vector{<:AbstractString};
    palette_size::Int = PALETTE_SIZE,
    aug_steps::Int = AUGMENT_STEPS,
    l_range = L_SHIFT_RANGE
)
    # load the dataset from the file if it exists, otherwise initialize an empty dataset
    if isfile(filename)
        @load filename X_total Y_total
    else
        X_total = Matrix{Float32}(undef, OKLAB_DIM, 0)
        Y_total = Matrix{Float32}(undef, OKLAB_DIM * palette_size, 0)
    end

    # Hex -> OKLab
    main_v   = hex_to_oklab_vec(hex_list[1])
    others_v = [hex_to_oklab_vec(h) for h in hex_list[2:end]]

    normalize_palette!(others_v, main_v, palette_size)

    # data augmentation
    for l_shift in range(l_range[1], l_range[2], length=aug_steps)
        aug_x, aug_y = augment_sample(main_v, others_v, Float32(l_shift))
        X_total = hcat(X_total, aug_x)
        Y_total = hcat(Y_total, aug_y)
    end

    @save filename X_total Y_total

    println("palette augmentation completed")
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

hex_list = prompt_palette(7)
save_augmented_palette("training_data/color_data.jld2", hex_list)

# Example Usage ( Demonstration purposes only. For formal training, please use our GUI or Batch Training )
#=
my_first_palette = [
    "#ABE7FF", # main color
    "#DAF0F9",
    "#F4F9FF"
]

save_augmented_palette("training_data/color_data.jld2", my_first_palette)

my_full_palette = [
    "#ABE7FF", # main color
    "#DAF0F9",
    "#F4F9FF",
    "#425573",
    "#CCCCCC",
    "#8C939F",
    "#D6EFFF"
]

save_augmented_palette("training_data/color_data.jld2", my_full_palette)
=#