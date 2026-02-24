# Place here configuration options that will be set for all environments
# ENV["GENIE_ENV"] = "prod"

const APP_ROOT = normpath(joinpath(@__DIR__, "..", "..", ".."))
ENV["APP_ROOT"] = APP_ROOT
ENV["ROOT_PARENT"] = dirname(APP_ROOT)

ENV["EXTERNAL_TRAINING_DATA_PATH"] = "training_data/color_data.jld2"

ENV["EXTERNAL_CUSTOM_AI_MODEL_PATH"] = "models/trained_color_model.jld2"
ENV["EXTERNAL_NEWEST_LYRA_MODEL_PATH"] = "models/Lyra2.0.jld2"