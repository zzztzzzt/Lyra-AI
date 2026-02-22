module PaletteProcessor

using JLD2

using LyraUtils.ColorOKLab
using LyraUtils.PaletteAugment

export
    save_augmented_palette,
    save_augmented_palette_using_oklch

const OKLAB_DIM = 3
const PALETTE_SIZE = 9
const AUGMENT_STEPS = 5
const LEGACY_PAIR_INPUT_SIZE = 7
const TRIPLET_INPUT_SIZE = 10

const L_DARK_THRESHOLD   = 0.50f0
const L_BRIGHT_THRESHOLD = 0.80f0

# 1. Tool Functions

#=
LEGACY Mode :
Input：[cMAIN, c1_start, c1_end, c2_start, c2_end, c3_start, c3_end]
Auto calculate mid-color between c_start and c_end
Output：[c1_start, c1_mid, c1_end, c2_start, c2_mid, c2_end, c3_start, c3_mid, c3_end]

TRIPLET Mode :
Input：[c1_start, c1_mid, c1_end, c2_start, c2_mid, c2_end, c3_start, c3_mid, c3_end]
Output：[c1_start, c1_mid, c1_end, c2_start, c2_mid, c2_end, c3_start, c3_mid, c3_end]
=#
function convert_pairs_to_gradients(hex_list::Vector{<:AbstractString})
    input_len = length(hex_list)
    if input_len != LEGACY_PAIR_INPUT_SIZE && input_len != TRIPLET_INPUT_SIZE
        error("Expected 7 (main + 3 pairs) or 10 (main + 3 pairs with mid color) colors, got $(input_len)")
    end
    
    main_v = hex_to_oklab_vec(hex_list[1])
    gradient_colors = Vector{Vector{Float32}}()

    if input_len == LEGACY_PAIR_INPUT_SIZE
        # legacy format: [main, a1, b1, a2, b2, a3, b3]
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
    else
        # triplet format: [main, a1, mid1, b1, a2, mid2, b2, a3, mid3, b3]
        for i in 0:2
            base = 2 + i * 3
            start_v = hex_to_oklab_vec(hex_list[base])
            mid_v = hex_to_oklab_vec(hex_list[base + 1])
            end_v = hex_to_oklab_vec(hex_list[base + 2])

            push!(gradient_colors, start_v)
            push!(gradient_colors, mid_v)
            push!(gradient_colors, end_v)
        end
    end
    
    return main_v, gradient_colors
end

#=
LEGACY Mode :
Input：[cMAIN, c1_start, c1_end, c2_start, c2_end, c3_start, c3_end]
Auto calculate mid-color between c_start and c_end
Output：[c1_start, c1_mid, c1_end, c2_start, c2_mid, c2_end, c3_start, c3_mid, c3_end]

TRIPLET Mode :
Input：[c1_start, c1_mid, c1_end, c2_start, c2_mid, c2_end, c3_start, c3_mid, c3_end]
Output：[c1_start, c1_mid, c1_end, c2_start, c2_mid, c2_end, c3_start, c3_mid, c3_end]
=#
function convert_pairs_to_gradients_using_oklch(oklch_list::AbstractVector{<:AbstractVector{<:Real}})
    input_len = length(oklch_list)
    if input_len != LEGACY_PAIR_INPUT_SIZE && input_len != TRIPLET_INPUT_SIZE
        error("Expected 7 (legacy) or 10 (triplet) colors, got $(input_len)")
    end
    
    main_v = oklch_to_oklab_vec(oklch_list[1])
    gradient_colors = Vector{Vector{Float32}}()

    if input_len == LEGACY_PAIR_INPUT_SIZE
        # legacy format: [main, a1, b1, a2, b2, a3, b3]
        for i in 1:3
            start_oklch = oklch_list[2*i] # index 2,4,6
            end_oklch = oklch_list[2*i + 1] # index 3,5,7

            start_v = oklch_to_oklab_vec(start_oklch)
            end_v = oklch_to_oklab_vec(end_oklch)

            # Auto calculate mid-color (50% linear interpolation)
            mid_v = 0.5f0 .* start_v .+ 0.5f0 .* end_v

            push!(gradient_colors, start_v)
            push!(gradient_colors, mid_v)
            push!(gradient_colors, end_v)
        end
    else
        # triplet format: [main, a1, mid1, b1, a2, mid2, b2, a3, mid3, b3]
        for i in 0:2
            base = 2 + i * 3
            start_v = oklch_to_oklab_vec(oklch_list[base])
            mid_v = oklch_to_oklab_vec(oklch_list[base + 1])
            end_v = oklch_to_oklab_vec(oklch_list[base + 2])

            push!(gradient_colors, start_v)
            push!(gradient_colors, mid_v)
            push!(gradient_colors, end_v)
        end
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

# 2. Primary APIs

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

#=
change OKLCH to OKLab, and save the augmented data to a JLD2 dataset

Dataset format:
- X : 3 × N (main color OKLab)
- Y : 27 × N (9 colors OKLab: 3 gradient sets)
=#
function save_augmented_palette_using_oklch(
    filename::AbstractString,
    oklch_list::AbstractVector{<:AbstractVector{<:Real}},
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

    main_v, others_v = convert_pairs_to_gradients_using_oklch(oklch_list)
    
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

end # module PaletteProcessor
