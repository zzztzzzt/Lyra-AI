# generate an augmented sample by scaling brightness (multiplicative).
function augment_sample_brightness(
    main_v::Vector{Float32},
    others_v::Vector{Vector{Float32}},
    l_scale::Float32
)
    # 1. Main Color
    aug_x = copy(main_v)
    # multiply directly by the ratio, ensuring it does not exceed 1.0
    aug_x[1] = clamp(aug_x[1] * l_scale, 0.0f0, 1.0f0)

    # 2. Other Colors
    aug_y = Float32[]
    for v in others_v
        v_new = copy(v)
        # all colors share the same scaling factor, maintaining a relative brightness relationship
        v_new[1] = clamp(v_new[1] * l_scale, 0.0f0, 1.0f0)
        append!(aug_y, v_new)
    end

    return aug_x, aug_y
end

# generate an augmentation sample based on chroma scaling
function augment_sample_chroma(
    main_v::Vector{Float32},
    others_v::Vector{Vector{Float32}},
    scale::Float32
)
    # main color
    aug_x = copy(main_v)
    aug_x[2] *= scale
    aug_x[3] *= scale

    # other colors
    aug_y = Float32[]
    for v in others_v
        v_new = copy(v)
        v_new[2] *= scale
        v_new[3] *= scale
        append!(aug_y, v_new)
    end

    return aug_x, aug_y
end