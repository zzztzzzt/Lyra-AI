using Lux, Random, Optimisers, Statistics, Zygote
using JLD2

# 1. Hyperparameters
const IN_DIM, OUT_DIM = 3, 27 # 3 Gradient Set × 3 Colors (3 Hex every set) × 3 Dimensions (LCH) = 27
const HIDDEN, BATCH_SIZE, N_EPOCHS, LR = 64, 16, 300, 1e-3

# 2. Load Data
@load "training_data/color_data.jld2" X_total Y_total
X, Y = Float32.(X_total), Float32.(Y_total)

println("⭐ ||||||  Dataset Info  |||||| ⭐")
println("Input shape (X): $(size(X))")
println("Output shape (Y): $(size(Y))")
println("Total samples: $(size(X, 2))")

# Validate data dimensions
if size(Y, 1) != OUT_DIM
    error("Expected Y dimension to be $(OUT_DIM), but got $(size(Y, 1)). Please regenerate your dataset with the new structure.")
end

# 3. Define Model (add LayerNorm to make colors more stable)
model = Chain(
    Dense(IN_DIM => HIDDEN, relu),
    LayerNorm((HIDDEN,)),
    Dense(HIDDEN => HIDDEN, relu),
    Dense(HIDDEN => OUT_DIM)
)

rng = Random.default_rng()
ps, st = Lux.setup(rng, model)
opt = Optimisers.Adam(LR)
tstate = Lux.Training.TrainState(model, ps, st, opt)

# 4. Training
println("Training Started")
for epoch in 1:N_EPOCHS
    global tstate 

    grads, loss, stats, tstate = Lux.Training.single_train_step!(
        AutoZygote(), 
        (m, p, s, d) -> (mean(abs2, Lux.apply(m, d[1], p, s)[1] .- d[2]), Lux.apply(m, d[1], p, s)[2], ()),
        (X, Y), tstate
    )
    
    if epoch % 50 == 0
        println("Epoch $epoch | Loss: $(round(loss, digits=6))")
    end
end

# 5. Save Model
@save "models/trained_color_model.jld2" tstate
println("⭐ ||||||  Training Complete  |||||| ⭐")
println("Model saved to: models/trained_color_model.jld2")
println("Output structure: 3 gradient triplets ( 9 colors total )")