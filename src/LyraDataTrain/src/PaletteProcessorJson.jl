module PaletteProcessorJson

using JSON

using LyraDataTrain.PaletteProcessor

export
    process_json_palettes

function process_json_palettes(json_file::String, output_file::String, is_oklch_json::Bool)
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

            if is_oklch_json
                oklch_list = [Float32.(c) for c in colors]

                # make sure at least one primary color
                if length(oklch_list) < 1
                    println("Warning: Palette $idx has no colors, skipping")
                    continue
                end
                
                # process each color palette
                try
                    save_augmented_palette_using_oklch(output_file, oklch_list)
                    total_processed += 1
                    
                    if palette isa Dict && haskey(palette, "name")
                        println("Processed palette: $(palette["name"])")
                    else
                        println("Processed palette #$idx")
                    end
                catch e
                    println("Error processing palette $idx: $e")
                end
            else
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
        end
    else
        error("JSON must contain a 'palettes' key")
    end
    
    println("Batch processing completed!")
    println("Total palettes processed: $total_processed")
end

end # module PaletteProcessorJson