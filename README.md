# Lyra
<br>
<img src="https://github.com/zzztzzzt/Lyra-AI/blob/main/logo/favicon.png" alt="lyra-logo" style="height: 280px; width: auto;" />

### Lyra is an AI for orchestrating colors/gradients in 3D environments.

IMPORTANT : This project is still in the development and testing stages, licensing terms may be updated in the future. Please don't do any commercial usage currently.

Lyra uses Lux.jl for deep learning. Lux.jl licensed under the MIT License.  
Lux.jl License : [https://github.com/LuxDL/Lux.jl/blob/main/LICENSE](https://github.com/LuxDL/Lux.jl/blob/main/LICENSE)

## How To Train

1. Install Julia : [https://github.com/JuliaLang/julia](https://github.com/JuliaLang/julia)

2. Download or git clone this project

3. cd project root & run `julia --project=. -e 'import Pkg; Pkg.instantiate()'`

4. Start training, here are 3 different ways

### Option 1. Training via GUI ( Recommended )

[ wip ]

### Option 2. Batch Training ( Recommended )

modify `training_data.json` at project root

JSON fromat example is at below

```json

{
    "palettes": [
        ["85FF80", "00C073", "CFFFBB", "8EFFA9", "95FFEC", "399A02", "68FFE1"],
        ["FF8282", "FF6363", "FFCB79", "FF5356", "FFE044", "FF655A", "FFE3E8"]
    ]
}

```

in project folder, command below

`julia --project=. scripts/build_data_batch.jl training_data.json`

after the dataset is enough, run training code

`julia --project=. scripts/train.jl`

your model will be saved in `models/trained_color_model.jld2`

### Option 3. CLI / Shell command

in project folder, command below

`julia --project=. scripts/build_data.jl`

if you choose " input all in once ", you can type in below format

`85FF80 00C073 CFFFBB 8EFFA9 95FFEC 399A02 68FFE1`

or

`"85FF80", "00C073", "CFFFBB", "8EFFA9", "95FFEC", "399A02", "68FFE1"`

if you choose " input one color everytime ", you can type in below format

`85FF80` or `"85FF80"`

after the dataset is enough, run training code

`julia --project=. scripts/train.jl`

your model will be saved in `models/trained_color_model.jld2`

### Final Step : Predict

run `julia --project=. scripts/predict.jl` to test

## Version History ( Datasets & Predictions )

#### Lyra 1.0 (2026.01) - Predictions
![1.0showcase](https://github.com/zzztzzzt/Lyra-AI/blob/main/training_data_showcase/Lyra1.0_predictions.jpg)

#### Lyra 1.0 (2026.01) - Datasets
![1.0showcase](https://github.com/zzztzzzt/Lyra-AI/blob/main/training_data_showcase/Lyra1.0_dataset_structure.webp)