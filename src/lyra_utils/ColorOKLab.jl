using LinearAlgebra

function srgb_to_linear(c)
    return c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055)^2.4
end

# Auxiliary: Decimal to Hexadecimal string conversion
hex(x, pad) = lpad(string(x, base=16), pad, '0')

function hex_to_oklab_vec(hex::String)
    hex = replace(hex, "#" => "")
    r = parse(Int, hex[1:2], base=16) / 255.0
    g = parse(Int, hex[3:4], base=16) / 255.0
    b = parse(Int, hex[5:6], base=16) / 255.0
    
    # Step A: Hex -> RGB -> Linear RGB
    l_rgb = srgb_to_linear.([r, g, b])
    
    # Step B: Linear RGB -> LMS space (using OKLAB transformation matrix M1)
    M1 = [0.4122214708 0.5363325363 0.0514459929;
          0.2119034982 0.6806995451 0.1073969566;
          0.0883024619 0.2817188376 0.6299787005]
    lms = M1 * l_rgb
    
    # Step C: Non-linear processing (Cube root)
    # Use sign and abs to handle potential negative values from floating-point errors
    lms_prime = sign.(lms) .* abs.(lms).^(1/3)

    # Step D: LMS -> OKLAB (using transformation matrix M2)
    M2 = [0.2104542553  0.7936177850 -0.0040720468;
          1.9779984951 -2.4285922050  0.4505937099;
          0.0259040371  0.7827717662 -0.8086757660]
    lab = M2 * lms_prime
    return Float32.(lab) # return [L, a, b]
end

# OKLab -> Linear RGB -> sRGB -> Hex
function oklab_to_hex(lab::AbstractVector)
    L, a, b = lab[1], lab[2], lab[3]
    
    # M2 inverse matrix (the inverse of LMS -> OKLab)
    M2_inv = [1.0 0.3963377774 0.2158037573;
              1.0 -0.1055613458 -0.0638541728;
              1.0 -0.0894841775 -1.2914855480]
    lms_prime = M2_inv * [L, a, b]
    lms = sign.(lms_prime) .* abs.(lms_prime).^3 # inverse operation of cube root
    
    # M1 inverse matrix (the inverse of Linear RGB -> LMS)
    M1_inv = [4.0767416621 -3.3077115913 0.2309699292;
             -1.2684380046 2.6097574011 -0.3413193965;
             -0.0041960863 -0.7034186147 1.7076147010]
    l_rgb = M1_inv * lms
    
    # Linear -> sRGB (Gamma correction)
    function linear_to_srgb(c)
        c = clamp(c, 0.0, 1.0)
        return c <= 0.0031308 ? 12.92 * c : 1.055 * (c^(1/2.4)) - 0.055
    end
    rgb = linear_to_srgb.(l_rgb)
    
    # Convert to Hex string
    r, g, b = Int.(round.(rgb .* 255))
    return "#" * uppercase(hex(r, 2) * hex(g, 2) * hex(b, 2))
end