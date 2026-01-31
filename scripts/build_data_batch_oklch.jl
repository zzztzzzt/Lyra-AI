using LyraDataTrain.PaletteProcessorJson

# Batch processing for OKLCH JSON
if abspath(PROGRAM_FILE) == @__FILE__
    if length(ARGS) < 1
        println("Usage: julia --project=. scripts/build_data_batch_oklch.jl <json_file> [output_file]")
        println("Example: julia --project=. scripts/build_data_batch_oklch.jl palettes.json")
        exit(1)
    end
    
    json_file = ARGS[1]
    output_file = length(ARGS) >= 2 ? ARGS[2] : "training_data/color_data.jld2"
    
    if !isfile(json_file)
        println("Error: JSON file '$json_file' not found")
        exit(1)
    end
    
    process_json_palettes(json_file, output_file, true)
end

#=
Example JSON

{
  "palettes": [
    [[0.92,0.141,252],[0.8,0.186,266],[1,0.06,225],[0.8,0.186,266],[1,0.131,225],[0.8,0.125,248],[1,0.131,225]],
    [[0.92,0.141,154],[0.92,0.131,164],[0.89,0.148,192],[0.92,0.131,164],[0.89,0.148,145],[0.92,0.192,194],[0.89,0.148,145]]
  ]
}

OR Details

{
  "palettes": [
    {
      "name": "light blue",
      "colors": [[0.92,0.141,252],[0.8,0.186,266],[1,0.06,225],[0.8,0.186,266],[1,0.131,225],[0.8,0.125,248],[1,0.131,225]]
    },
    {
      "name": "green",
      "colors": [[0.92,0.141,154],[0.92,0.131,164],[0.89,0.148,192],[0.92,0.131,164],[0.89,0.148,145],[0.92,0.192,194],[0.89,0.148,145]]
    }
  ]
}
=#