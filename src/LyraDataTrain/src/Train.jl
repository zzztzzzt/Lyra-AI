module Train

using Lux, MLUtils, Random, Optimisers, Statistics, Zygote, JLD2, NNlib

export
    train_from_file

# 1. Hyperparameters
const IN_DIM, OUT_DIM = 3, 27
const HIDDEN, BATCH_SIZE, N_EPOCHS, LR = 64, 16, 300, 1e-3
const TRAIN_RATIO = 0.8
# L1 + L2 mixed weights
const L1_WEIGHT = 0.7f0
const L2_WEIGHT = 0.3f0

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

    # split train / val
    n_samples = size(X, 2)

    # shuffle
    rng = Random.default_rng()
    perm = randperm(rng, n_samples)
    X = X[:, perm]
    Y = Y[:, perm]

    split_idx = floor(Int, TRAIN_RATIO * n_samples)
    
    X_train = X[:, 1:split_idx]
    Y_train = Y[:, 1:split_idx]
    X_val   = X[:, split_idx+1:end]
    Y_val   = Y[:, split_idx+1:end]

    println("Train samples: $split_idx | Val samples: $(n_samples - split_idx)")

    train_loader = DataLoader((X_train, Y_train);
        batchsize = BATCH_SIZE,
        shuffle = true, # reshuffle every epoch
        partial = true
    )

    val_loader = DataLoader((X_val, Y_val);
        batchsize = BATCH_SIZE * 2, # use a larger batch size to speed up the process
        shuffle = false,
        partial = true
    )

    # 3. Define Model (add LayerNorm to make colors more stable)
    model = Chain(
        Dense(IN_DIM => HIDDEN, mish),
        LayerNorm((HIDDEN,)),
        Dense(HIDDEN => HIDDEN, mish),
        Dense(HIDDEN => OUT_DIM)
    )

    rng = Random.default_rng()
    ps, st = Lux.setup(rng, model)

    # weight decay
    opt = Optimisers.OptimiserChain(
        Optimisers.WeightDecay(Float32(1e-5)),
        Optimisers.Adam(LR)
    )

    tstate = Lux.Training.TrainState(model, ps, st, opt)

    # 4. Training
    println("Training Started ( using mish + L1+L2 loss + val set )")
    for epoch in 1:N_EPOCHS
        total_train_loss = 0.0f0
        n_train_batches = 0

        for (x_batch, y_batch) in train_loader
            grads, loss, stats, tstate = Lux.Training.single_train_step!(
                AutoZygote(),
                (m, p, s, d) -> begin
                    pred, st_new = Lux.apply(m, d[1], p, s)
                    diff = pred .- d[2]
                    l1 = mean(abs, diff)
                    l2 = mean(diff .^ 2f0)
                    l = L1_WEIGHT * l1 + L2_WEIGHT * l2
                    return (l, st_new, ()) # loss, new state, empty stats
                end,
                (x_batch, y_batch),
                tstate
            )
            total_train_loss += loss
            n_train_batches += 1
        end

        avg_train_loss = total_train_loss / n_train_batches

        # Validation
        val_loss_sum = 0.0f0
        val_n_samples = 0
        for (x_valb, y_valb) in val_loader
            pred, _ = Lux.apply(model, x_valb, tstate.parameters, tstate.states)
            diff = pred .- y_valb
            l1 = mean(abs, diff)
            l2 = mean(diff .^ 2f0)
            l = L1_WEIGHT * l1 + L2_WEIGHT * l2
            val_loss_sum += l * size(x_valb, 2) # weighted by batch size
            val_n_samples += size(x_valb, 2)
        end
        avg_val_loss = val_loss_sum / val_n_samples

        if epoch % 50 == 0 || epoch == N_EPOCHS
            println("Epoch $epoch | Train Loss: $(round(avg_train_loss, digits=6)) | Val Loss: $(round(avg_val_loss, digits=6))")
        end
    end

    # 5. Save Model
    @save model_path tstate
    println("⭐ ||||||  Training Complete  |||||| ⭐")
    println("Model saved to: $model_path")
    println("Final Train Loss: $(round(avg_train_loss, digits=6)) | Final Val Loss: $(round(avg_val_loss, digits=6))")
end

end # module Train