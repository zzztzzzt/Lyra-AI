using JSON
include("build_data.jl")

function process_json_palettes(json_file::String, output_file::String)
    data = JSON.parsefile(json_file)
    
    total_processed = 0
    
    # Check JSON format and process
    if haskey(data, "palettes")
        palettes = data["palettes"]
        
        for (idx, palette) in enumerate(palettes)
            # For Debugging
            #println("Palette $idx type = ", typeof(palette))
            #println("Palette $idx content = ", palette)

            # support 2 JSON format
            colors = if palette isa Vector
                palette # simple array format ( for example see bottom of the code )
            elseif (palette isa Dict{String,Any} || palette isa JSON.Object{String,Any}) && haskey(palette, "colors")
                palette["colors"] # name-included format ( for example see bottom of the code )
            else
                println("Warning: Skipping invalid palette at index $idx")
                continue
            end

            # Forced change to Vector{String}
            colors_str = String[string(c) for c in colors]
            
            # make sure at least one primary color
            if length(colors_str) < 1
                println("Warning: Palette $idx has no colors, skipping")
                continue
            end
            
            # process each color palette
            try
                save_augmented_palette(output_file, colors_str)
                total_processed += 1
                
                if palette isa Dict && haskey(palette, "name")
                    println("Processed palette: $(palette["name"])")
                else
                    println("Processed palette #$idx")
                end
            catch e
                println("Error processing palette $idx: $e")
            end
        end
    else
        error("JSON must contain a 'palettes' key")
    end
    
    println("Batch processing completed!")
    println("Total palettes processed: $total_processed")
end

# Batch processing
if abspath(PROGRAM_FILE) == @__FILE__
    if length(ARGS) < 1
        println("Usage: julia --project=. scripts/build_data_batch.jl <json_file> [output_file]")
        println("Example: julia --project=. scripts/build_data_batch.jl palettes.json")
        exit(1)
    end
    
    json_file = ARGS[1]
    output_file = length(ARGS) >= 2 ? ARGS[2] : "training_data/color_data.jld2"
    
    if !isfile(json_file)
        println("Error: JSON file '$json_file' not found")
        exit(1)
    end
    
    process_json_palettes(json_file, output_file)
end

#=
Example JSON

{
  "palettes": [
    ["#86FFB1", "#ADF2D1", "#006D1D", "#E0FFD7", "#79FF94", "#3FFFBF", "#BDFFD4"],
    ["#FFED86", "#F9F3DA", "#FFFDF4", "#F9FF55", "#E0E0E0", "#FFF1DA", "#FFFCD6"]
  ]
}

OR Details

{
  "palettes": [
    {
      "name": "light green",
      "colors": ["#86FFB1", "#ADF2D1", "#006D1D", "#E0FFD7", "#79FF94", "#3FFFBF", "#BDFFD4"]
    },
    {
      "name": "yellow",
      "colors": ["#FFED86", "#F9F3DA", "#FFFDF4", "#F9FF55", "#E0E0E0", "#FFF1DA", "#FFFCD6"]
    }
  ]
}
=#