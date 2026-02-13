module Train

using Lux, MLUtils, Random, Optimisers, Statistics, Zygote, JLD2

export
    train_from_file

# 1. Hyperparameters
const IN_DIM, OUT_DIM = 3, 27 # Input : main color in OKLab (L, a, b). Output : relative OKLab offsets for 9 colors (3 gradient sets × 3 colors × 3 dims)
const HIDDEN, BATCH_SIZE, N_EPOCHS, LR = 64, 16, 300, 1e-3

function train_from_file(data_path::String, model_path::String)
    # 2. Load Data
    @load data_path X_total Y_total
    X, Y = Float32.(X_total), Float32.(Y_total)

    # convert absolute colors to relative offsets
    Y_offset = similar(Y)

    for i in 1:size(X, 2)
        main = X[:, i] # 3
        main_repeat = repeat(main, 9) # 27
        Y_offset[:, i] = Y[:, i] .- main_repeat
    end

    # Train by replacing the original Y with the offset, so AI will learn the offset relative to the main color, not the absolute color
    Y = Y_offset

    println("⭐ ||||||  Dataset Info  |||||| ⭐")
    println("Input shape (X): $(size(X))")
    println("Output shape (Y): $(size(Y))")
    println("Total samples: $(size(X, 2))")

    # Validate data dimensions
    if size(Y, 1) != OUT_DIM
        error("Expected Y dimension to be $(OUT_DIM), but got $(size(Y, 1)). Please regenerate your dataset with the new structure.")
    end

    train_loader = DataLoader((X, Y);
        batchsize = BATCH_SIZE,
        shuffle = true, # reshuffle every epoch
        partial = true # avoid dropping the last few samples
    )

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
        total_loss = 0.0f0
        n_batches = 0

        for (x_batch, y_batch) in train_loader
            grads, loss, stats, tstate = Lux.Training.single_train_step!(
                AutoZygote(),
                (m, p, s, d) -> begin
                    pred, st_new = Lux.apply(m, d[1], p, s)
                    l = mean(abs, pred .- d[2])
                    return (l, st_new, ()) # loss, new state, empty stats
                end,
                (x_batch, y_batch),
                tstate
            )
            total_loss += loss
            n_batches += 1
        end

        if epoch % 50 == 0
            avg_loss = total_loss / n_batches
            println("Epoch $epoch | Avg Loss: $(round(avg_loss, digits=6))")
        end
    end

    # 5. Save Model
    @save model_path tstate
    println("⭐ ||||||  Training Complete  |||||| ⭐")
    println("Model saved to: models/trained_color_model.jld2")
    println("Output structure: 3 gradient triplets ( 9 colors total )")
end

end # module Train