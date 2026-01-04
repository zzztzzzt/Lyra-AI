# generate an augmentation sample based on the brightness offset.
function augment_sample_brightness(
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

function apply_subtle_noise(vec::Vector{Float32}; l_std=0.01f0, ab_std=0.005f0)
    noise = [
        randn(Float32) * l_std, # slight adjustment to lightness
        randn(Float32) * ab_std, # slight adjustment to a channel
        randn(Float32) * ab_std # slight adjustment to b channel
    ]
    return vec .+ noise
end