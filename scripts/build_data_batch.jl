using LyraDataTrain.PaletteProcessorJson

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
    
    process_json_palettes(json_file, output_file, false)
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