using Genie.Router

using .PredictsController
using .TrainingsController

route("/") do
  serve_static_file("welcome.html")
end

route("/api/predict", PredictsController.generate, method = GET)
route("/api/train", TrainingsController.process_palettes, method = POST)