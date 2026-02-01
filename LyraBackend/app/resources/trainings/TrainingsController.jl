module TrainingsController

using Genie.Renderer.Json, Genie.Requests
using JSON

using LyraDataTrain.PaletteProcessorJson
using LyraDataTrain.Train

function process_palettes()
  try
    payload = jsonpayload()
    
    if !haskey(payload, "palettes")
      return Json.json(
        Dict(:error => "Missing 'palettes' field in JSON"),
        status = 400
      )
    end
    
    palettes = payload["palettes"]
    
    if !isa(palettes, Vector)
      return Json.json(
          Dict(:error => "'palettes' must be an array"),
          status = 400
      )
    end
    
    dataset_output_file = joinpath(ENV["ROOT_PARENT"], ENV["EXTERNAL_TRAINING_DATA_PATH"])
    
    process_json_palettes(payload, dataset_output_file, true)

    model_saving_path = joinpath(ENV["ROOT_PARENT"], ENV["EXTERNAL_CUSTOM_AI_MODEL_PATH"])

    train_from_file(dataset_output_file, model_saving_path)

    return Json.json(
      Dict(
        :status => "success",
        :message => "Palette processed and Model trained successfully",
      ),
      status = 200
    )

  catch e
    @error "Error processing palettes" exception=(e, catch_backtrace())
    return Json.json(
      Dict(
        :error => "Internal server error"
      ),
      status = 500
    )
  end
end

end # module TrainingsController
