using Genie.Router

using .PredictsController

route("/") do
  serve_static_file("welcome.html")
end

route("/api/predict", PredictsController.generate, method = GET)