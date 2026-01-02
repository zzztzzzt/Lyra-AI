using Lux, Random, Optimisers, Statistics, Zygote
using JLD2

# 1. Hyperparameters
const IN_DIM, OUT_DIM = 3, 18
const HIDDEN, BATCH_SIZE, N_EPOCHS, LR = 64, 16, 300, 1e-3

# 2. Load Data
@load "training_data/color_data.jld2" X_total Y_total
X, Y = Float32.(X_total), Float32.(Y_total)

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
println("Training started, total samples: $(size(X, 2))")
for epoch in 1:N_EPOCHS
    global tstate 

    grads, loss, stats, tstate = Lux.Training.single_train_step!(
        AutoZygote(), 
        (m, p, s, d) -> (mean(abs2, Lux.apply(m, d[1], p, s)[1] .- d[2]), Lux.apply(m, d[1], p, s)[2], ()),
        (X, Y), tstate
    )
    
    if epoch % 50 == 0
        println("Epoch $epoch | Loss: $loss")
    end
end

# 5. Save Model
@save "trained_color_model.jld2" tstate
println("AI training completed")