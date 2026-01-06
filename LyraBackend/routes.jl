using Genie.Router

include("app/resources/predicts/predictsController.jl")
using .PredictsController

route("/") do
  serve_static_file("welcome.html")
end

route("/api/predict", PredictsController.generate, method = GET)