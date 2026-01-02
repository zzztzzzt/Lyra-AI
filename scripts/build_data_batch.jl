using JSON
include("build_data.jl")

function process_json_palettes(json_file::String, output_file::String)
    data = JSON.parsefile(json_file)
    
    total_processed = 0
    
    # Check JSON format and process
    if haskey(data, "palettes")
        palettes = data["palettes"]
        
        for (idx, palette) in enumerate(palettes)
            # support 2 JSON format
            colors = if palette isa Vector
                palette # simple array format ( for example see bottom of the code )
            elseif palette isa Dict && haskey(palette, "colors")
                palette["colors"] # name-included format ( for example see bottom of the code )
            else
                println("Warning: Skipping invalid palette at index $idx")
                continue
            end
            
            # make sure at least one primary color
            if length(colors) < 1
                println("Warning: Palette $idx has no colors, skipping")
                continue
            end
            
            # process each color palette
            try
                save_augmented_palette(output_file, colors)
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
    
    println("\n" * "="^50)
    println("Batch processing completed!")
    println("Total palettes processed: $total_processed")
    println("="^50)
end

# Batch processing
if abspath(PROGRAM_FILE) == @__FILE__
    if length(ARGS) < 1
        println("Usage: julia --project=. scripts/build_data_batch.jl <json_file> [output_file]")
        println("Example: julia --project=. scripts/build_data_batch.jl palettes.json")
        exit(1)
    end
    
    json_file = ARGS[1]
    output_file = length(ARGS) >= 2 ? ARGS[2] : "../training_data/color_data.jld2"
    
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
    ["#86DDFF", "#DAF0F9", "#F4F9FF", "#425573", "#CCCCCC", "#8C939F", "#D6EFFF"],
    ["#FF6B6B", "#FFE66D", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEAA7", "#DFE6E9"]
  ]
}

OR Details

{
  "palettes": [
    {
      "name": "Ocean Blue",
      "colors": ["#86DDFF", "#DAF0F9", "#F4F9FF", "#425573", "#CCCCCC", "#8C939F", "#D6EFFF"]
    },
    {
      "name": "Sunset Warm",
      "colors": ["#FF6B6B", "#FFE66D", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEAA7", "#DFE6E9"]
    }
  ]
}
=#