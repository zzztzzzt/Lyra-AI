# Lyra
<br>
<img src="https://github.com/zzztzzzt/Lyra-AI/blob/main/logo/favicon.png" alt="lyra-logo" style="height: 280px; width: auto;" />

### Lyra is an AI for orchestrating colors/gradients in 3D environments.

IMPORTANT : This project is still in the development and testing stages, licensing terms may be updated in the future. Please don't do any commercial usage currently.

![Julia](https://img.shields.io/badge/Julia-9558B2?style=for-the-badge&logo=julia&logoColor=white)
![LuxJl](https://img.shields.io/badge/Lux.jl-9558B2?style=for-the-badge&logo=julia&logoColor=white)
![GenieJl](https://img.shields.io/badge/Genie.jl-9558B2?style=for-the-badge&logo=julia&logoColor=white)
![React](https://img.shields.io/badge/React-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![Vite](https://img.shields.io/badge/Vite-9135FF?style=for-the-badge&logo=vite&logoColor=white)
![UnoCSS](https://img.shields.io/badge/Uno_CSS-333333?style=for-the-badge&logo=unocss&logoColor=white)

Lyra uses Lux.jl for deep learning. Lux.jl licensed under the MIT License.  
Lux.jl License : [https://github.com/LuxDL/Lux.jl/blob/main/LICENSE](https://github.com/LuxDL/Lux.jl/blob/main/LICENSE)

## How To Train

1. Install Julia : [https://github.com/JuliaLang/julia](https://github.com/JuliaLang/julia)

2. Download or git clone this project

3. cd project root & run below : 

```shell
julia
```
```shell
]
```
```shell
activate .
```
```shell
instantiate
```
```shell
dev src/LyraUtils
```
```shell
dev src/LyraDataTrain
```

and type `backspace` to close pkg mode
type `Ctrl + D` to close Julia REPL

4. Start training, here are 3 different ways

### Option 1. Training via GUI ( Recommended )

[ wip ]

1. Let your CLI / shell go into folder `/LyraBackend/`. And run below : 
`( Genie Backend is in different environment, so even you already ran below command at project root, you still need to run it again here. )`

```shell
julia
```
```shell
]
```
```shell
activate .
```
```shell
instantiate
```
```shell
dev src/LyraUtils
```
```shell
dev src/LyraDataTrain
```
```shell
using Genie
```
```shell
Genie.loadapp()
```
```shell
up()
```

2. Open another CLI / shell, go into project root folder, then go into folder `/LyraGUI/`. And run below : 

```shell
npm install
```
```shell
npm run dev
```

open the URL on your CLI / shell.
after training, your model will be saved in `models/trained_color_model.jld2`

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

after the dataset is enough, run training code

`julia --project=. scripts/train.jl`

your model will be saved in `models/trained_color_model.jld2`

### Final Step : Predict

run `julia --project=. scripts/predict.jl` to test

## Project Debug

## Version History ( Training Process & Predictions )

#### Lyra 1.0 (2026.01) - Predictions
![1.0showcase](https://github.com/zzztzzzt/Lyra-AI/blob/main/training_data_showcase/Lyra1.0_predictions.jpg)

#### Lyra 1.0 (2026.01) - Training Process
![1.0showcase](https://github.com/zzztzzzt/Lyra-AI/blob/main/training_data_showcase/Lyra1.0_training_process.webp)