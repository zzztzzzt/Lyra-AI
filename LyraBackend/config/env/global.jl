# Place here configuration options that will be set for all environments
# ENV["GENIE_ENV"] = "prod"

const APP_ROOT = normpath(joinpath(@__DIR__, "..", "..", ".."))
ENV["APP_ROOT"] = APP_ROOT
ENV["ROOT_PARENT"] = dirname(APP_ROOT)