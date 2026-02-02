# Lyra

[![Hugging Face Model](https://img.shields.io/badge/-HuggingFace-3B4252?style=flat&logo=huggingface&logoColor=)](https://huggingface.co/zzztzzzt)
[![GitHub last commit](https://img.shields.io/github/last-commit/zzztzzzt/Lyra-AI.svg)](https://github.com/zzztzzzt/Lyra-AI)
[![GitHub repo size](https://img.shields.io/github/repo-size/zzztzzzt/Lyra-AI.svg)](https://github.com/zzztzzzt/Lyra-AI)

<br>
<img src="https://github.com/zzztzzzt/Lyra-AI/blob/main/logo/favicon.png" alt="lyra-logo" style="height: 280px; width: auto;" />

### Lyra is an AI for orchestrating colors/gradients in 3D environments.

IMPORTANT : This project is still in the development and testing stages, licensing terms may be updated in the future. Please don't do any commercial usage currently.

[![Julia](https://img.shields.io/badge/Julia-9558B2?style=for-the-badge&logo=julia&logoColor=white)](https://github.com/JuliaLang/julia)
[![LuxJl](https://img.shields.io/badge/Lux.jl-9558B2?style=for-the-badge&logo=julia&logoColor=white)](https://github.com/LuxDL/Lux.jl)
[![GenieJl](https://img.shields.io/badge/Genie.jl-9558B2?style=for-the-badge&logo=julia&logoColor=white)](https://github.com/GenieFramework/Genie.jl)
[![React](https://img.shields.io/badge/React-61DAFB?style=for-the-badge&logo=react&logoColor=black)](https://github.com/facebook/react)
[![Vite](https://img.shields.io/badge/Vite-9135FF?style=for-the-badge&logo=vite&logoColor=white)](https://github.com/vitejs/vite)
[![UnoCSS](https://img.shields.io/badge/Uno_CSS-333333?style=for-the-badge&logo=unocss&logoColor=white)](https://github.com/unocss/unocss)

Lyra uses Lux.jl for deep learning. Lux.jl licensed under the MIT License.  
Lux.jl License : [https://github.com/LuxDL/Lux.jl/blob/main/LICENSE](https://github.com/LuxDL/Lux.jl/blob/main/LICENSE)

Lyra uses Genie.jl for Training-GUI Backend. Genie.jl licensed under the MIT License.
Genie.jl License : [https://github.com/GenieFramework/Genie.jl/blob/main/LICENSE.md](https://github.com/GenieFramework/Genie.jl/blob/main/LICENSE.md)

Lyra uses React, UnoCSS for Training-GUI Design. And uses Vite as build tool. React, UnoCSS & Vite licensed under the MIT License.

React License : [https://github.com/facebook/react/blob/main/LICENSE](https://github.com/facebook/react/blob/main/LICENSE)
<br>
UnoCSS License : [https://github.com/unocss/unocss/blob/main/LICENSE](https://github.com/unocss/unocss/blob/main/LICENSE)
<br>
Vite License : [https://github.com/vitejs/vite/blob/main/LICENSE](https://github.com/vitejs/vite/blob/main/LICENSE)

## How To Train

1. Install Julia : [https://julialang.org/](https://julialang.org/)

2. Download or git clone this project

3. cd project root & run below : 

`julia`

`] activate .`

`instantiate`

`dev src/LyraUtils`

`dev src/LyraDataTrain`

and press `backspace` to close pkg mode

press `Ctrl + D` to close Julia REPL

4. Start training, here are 3 different ways

### Option 1. Training via GUI ( Recommended )

[ wip ]

1. Let your CLI / shell go into folder `/LyraBackend/`. And run below : 

`( Genie Backend is in different environment, so even you already ran below command at project root, you still need to run it again here. )`

`julia`

`] activate .`

`instantiate`

`dev ../src/LyraUtils`

`dev ../src/LyraDataTrain`

and below is the process you need to run `every time when you open LyraBackend` : 

make sure you already run `julia` & `] activate .`

press `backspace`

`using Genie`

`Genie.loadapp()`

`up()`

and then your backend app is running now

2. Download Node.js : [https://nodejs.org/](https://nodejs.org/)

3. Open another CLI / shell, go into project root folder, then go into folder `/LyraGUI/`. And run below : 

`npm install`

`npm run dev`

open the URL on your CLI / shell.

after training, your model will be saved in `models/trained_color_model.jld2`

### Option 2. Batch Training ( Recommended )

modify `training_data_example_oklch.json` or `training_data_example.json` at project root

JSON fromat example is at below, here are 2 ways to build dataset : 

1. OKLCH

```json

{
    "palettes": [
        [[0.92,0.141,252],[0.8,0.186,266],[1,0.06,225],[0.8,0.186,266],[1,0.131,225],[0.8,0.125,248],[1,0.131,225]],
        [[0.92,0.141,154],[0.92,0.131,164],[0.89,0.148,192],[0.92,0.131,164],[0.89,0.148,145],[0.92,0.192,194],[0.89,0.148,145]]
    ]
}

```

in project folder, command below

`julia --project=. scripts/build_data_batch_oklch.jl training_data_example_oklch.json`

OR

2. HEX

```json

{
    "palettes": [
        ["85FF80", "00C073", "CFFFBB", "8EFFA9", "95FFEC", "399A02", "68FFE1"],
        ["FF8282", "FF6363", "FFCB79", "FF5356", "FFE044", "FF655A", "FFE3E8"]
    ]
}

```

in project folder, command below

`julia --project=. scripts/build_data_batch.jl your_hex_training_data_example.json`

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

after the dataset is enough, run training code

`julia --project=. scripts/train.jl`

your model will be saved in `models/trained_color_model.jld2`

### Final Step : Predict

run `julia --project=. scripts/predict.jl` to test

## Project Detail / Debug

1. Now /src/ folder have 2 customized pkg ( `LyraUtils` & `LyraDataTrain` ). To add new pkg, you need to run below at /src/ : 

`julia`

`] generate YourNewPkgName`

( all your jl codes needs to be `module` type )

2. If you add any new dependencies into your customized pkg's `project.toml`, you need to run below command on `every environment` which is using your customized pkg ( or it won't auto update )

`julia`

`] activate .`

`dev src/YourNewPkgName`

3. If your pkg problems still exist, try below command too : 

( it will check the package dependencies )

`julia`

`] activate .`

`resolve`

4. At LyraBackend ( Genie.jl ), if you want to create new Controller & resource, run below at /LyraBackend/ : 

`julia --project=.`

`using Genie`

`Genie.Generator.newresource("TheName")`

## Version History ( Training Process & Predictions )

#### Lyra 1.5 (2026.02) - Predictions
![1.5showcase](https://github.com/zzztzzzt/Lyra-AI/blob/main/training_data_showcase/Lyra1.5_predictions.jpg)

#### Lyra 1.0 (2026.01) - Predictions
![1.0showcase](https://github.com/zzztzzzt/Lyra-AI/blob/main/training_data_showcase/Lyra1.0_predictions.jpg)

#### Lyra 1.0 (2026.01) - Training Process
![1.0showcase](https://github.com/zzztzzzt/Lyra-AI/blob/main/training_data_showcase/Lyra1.0_training_process.webp)