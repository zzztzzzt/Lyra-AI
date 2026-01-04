using JLD2
include("../src/lyra_utils/ColorOKLab.jl")
include("../src/lyra_utils/PaletteAugment.jl")

const OKLAB_DIM = 3
const PALETTE_SIZE = 6
const AUGMENT_STEPS = 10

const CHROMA_SCALE_RANGE = (0.9f0, 1.1f0)
const L_SHIFT_RANGE = (-0.15f0, 0.15f0)

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
    chroma_range = CHROMA_SCALE_RANGE,
    l_shift_range = L_SHIFT_RANGE
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

    # Hex -> OKLab
    main_v = hex_to_oklab_vec(hex_list[1])
    others_v = [hex_to_oklab_vec(h) for h in hex_list[2:end]]

    normalize_palette!(others_v, main_v, palette_size)

    # Chroma augmentation
    for scale in range(
        chroma_range[1],
        chroma_range[2],
        length=aug_steps
    )
        aug_x, aug_y = augment_sample_chroma(main_v, others_v, Float32(scale))
        X_total = hcat(X_total, aug_x)
        Y_total = hcat(Y_total, aug_y)
    end

    # Brightness / Lightness augmentation
    for shift in range(
        l_shift_range[1],
        l_shift_range[2],
        length=aug_steps
    )
        aug_x, aug_y = augment_sample_brightness(main_v, others_v, Float32(shift))
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
my_first_palette = [
    "#ABE7FF", # main color
    "#DAF0F9",
    "#F4F9FF"
]

save_augmented_palette("../training_data/color_data.jld2", my_first_palette)

my_full_palette = [
    "#ABE7FF", # main color
    "#DAF0F9",
    "#F4F9FF",
    "#425573",
    "#CCCCCC",
    "#8C939F",
    "#D6EFFF"
]

save_augmented_palette("../training_data/color_data.jld2", my_full_palette)
=#