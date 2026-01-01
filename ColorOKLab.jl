using LinearAlgebra

# 1. Convert Hex string to RGB values (0.0 - 1.0)
function hex_to_rgb(hex::String)
    hex = replace(hex, "#" => "")
    r = parse(Int, hex[1:2], base=16) / 255.0
    g = parse(Int, hex[3:4], base=16) / 255.0
    b = parse(Int, hex[5:6], base=16) / 255.0
    return [r, g, b]
end

# 2. Convert sRGB to Linear RGB (Remove Gamma correction)
function srgb_to_linear(c)
    return c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055)^2.4
end

function hex_to_oklab(hex_str::String)
    # Step A: Hex -> RGB -> Linear RGB
    rgb = hex_to_rgb(hex_str)
    l_rgb = srgb_to_linear.(rgb)

    # Step B: Linear RGB -> LMS space (using OKLAB transformation matrix M1)
    M1 = [0.4122214708 0.5363325363 0.0514459929;
          0.2119034982 0.6806995451 0.1073969566;
          0.0883024619 0.2817188976 0.6299786405]
    lms = M1 * l_rgb
    
    # Step C: Non-linear processing (Cube root)
    # Use sign and abs to handle potential negative values from floating-point errors
    lms_prime = sign.(lms) .* abs.(lms).^(1/3)

    # Step D: LMS -> OKLAB (using transformation matrix M2)
    M2 = [0.2104542553  0.7936177850 -0.0040720403;
          1.9779984951 -2.4285922050  0.4505937099;
          0.0259040371  0.7827717662 -0.8086757660]
    lab = M2 * lms_prime

    L, a, b = lab[1], lab[2], lab[3]

    # Step E: OKLAB -> OKLCH
    C = sqrt(a^2 + b^2)
    # If Chroma is near zero (grayscale), Hue is undefined (NaN)
    # Using mod(..., 360) is a cleaner way to wrap the angle
    h = C < 1e-6 ? NaN : mod(rad2deg(atan(b, a)), 360)

    return (L=L, a=a, b=b, C=C, h=h)
end

# Execution and Output
hex_input = "#4A90E2"
result = hex_to_oklab(hex_input)

println("Hex: $hex_input")
println("OKLAB: L=$(round(result.L, digits=4)), a=$(round(result.a, digits=4)), b=$(round(result.b, digits=4))")
println("OKLCH: L=$(round(result.L, digits=4)), C=$(round(result.C, digits=4)), h=$(round(result.h, digits=2))°")