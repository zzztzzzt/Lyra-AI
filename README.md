# Lyra-Core

[![Hugging Face Model](https://img.shields.io/badge/-HuggingFace-3B4252?style=flat&logo=huggingface&logoColor=)](https://huggingface.co/zzztzzzt)
[![GitHub last commit](https://img.shields.io/github/last-commit/zzztzzzt/Lyra-AI.svg)](https://github.com/zzztzzzt/Lyra-AI)
[![GitHub repo size](https://img.shields.io/github/repo-size/zzztzzzt/Lyra-AI.svg)](https://github.com/zzztzzzt/Lyra-AI)

<br>

<img src="https://github.com/zzztzzzt/Lyra-AI/blob/main/logo/logo.png" alt="lyra-logo" style="height: 280px; width: auto;" />

### Lyra - AI for color orchestrating / color harmony.

IMPORTANT : This project is still in the development and testing stages, licensing terms may be updated in the future. Please don't do any commercial usage currently.

## Project Dependencies Guide

[![Julia](https://img.shields.io/badge/Julia-9558B2?style=for-the-badge&logo=julia&logoColor=white)](https://github.com/JuliaLang/julia)
[![LuxJl](https://img.shields.io/badge/Lux.jl-9558B2?style=for-the-badge&logo=julia&logoColor=white)](https://github.com/LuxDL/Lux.jl)
[![GenieJl](https://img.shields.io/badge/Genie.jl-9558B2?style=for-the-badge&logo=julia&logoColor=white)](https://github.com/GenieFramework/Genie.jl)
[![React](https://img.shields.io/badge/React-61DAFB?style=for-the-badge&logo=react&logoColor=black)](https://github.com/facebook/react)
[![Vite](https://img.shields.io/badge/Vite-9135FF?style=for-the-badge&logo=vite&logoColor=white)](https://github.com/vitejs/vite)
[![UnoCSS](https://img.shields.io/badge/Uno_CSS-333333?style=for-the-badge&logo=unocss&logoColor=white)](https://github.com/unocss/unocss)

**[ for Dependencies Details please see the end of this README ]**

Lyra uses Lux.jl for deep learning. Lux.jl licensed under the MIT License.  

Lyra uses Genie.jl for Training-GUI Backend. Genie.jl licensed under the MIT License.

Lyra uses React, UnoCSS for Training-GUI Design. And uses Vite as build tool. React, UnoCSS & Vite licensed under the MIT License.

![main](https://github.com/zzztzzzt/Lyra-AI/blob/main/training_showcase/Lyra2.5_main.png)

**( Lyra 2.5 - Predictions )**

![2.5showcase](https://github.com/zzztzzzt/Lyra-AI/blob/main/training_showcase/Lyra2.5_predictions.png)

## How It Works

### 1. Gradient Definition

the training system uses 3 colors to make 1 gradient.
color-start + color-mid + color-end.

GUI uses **OKLCH** to define color.
GUI uses **OKLAB** to present gradients.
Training Systen uses **OKLAB** for training.

### 2. Training Data Preparing

the data structure : Main Color + 3 Gradients ( start + mid + end ).
total : 1 + 3 x 3 = 10 colors.

AI will learn the **offset** between Main Color & Other Colors.
so the actual training data : Main Color + 9 Offsets.

### 3. Training Process

use **Mish** activation function to make continuous gradient color changes.
mix L1 & L2.

Increase the penalty to force the model to avoid producing overly similar gradient colors.

## How To Train

#### 1. Install Julia : [https://julialang.org/](https://julialang.org/)

#### 2. Download or git clone this project

#### 3. cd project root & run below : 

`julia`

`] activate .`

`instantiate`

`dev src/LyraUtils`

`dev src/LyraDataTrain`

and press `backspace` to close pkg mode

press `Ctrl + D` to close Julia REPL

#### 4. Start training, here are 3 different ways : 

### Option 1. Training via GUI ( Recommended )

![GUI-01](https://github.com/zzztzzzt/Lyra-AI/blob/main/training_showcase/gui-01.webp)

#### ( You can change training mode ( Palette or Gradient ) to fit your color-set style )

![GUI-02](https://github.com/zzztzzzt/Lyra-AI/blob/main/training_showcase/gui-02.webp)

#### 1. Let your CLI / shell go into folder `/LyraBackend/`. And run below : 

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

#### 2. Download Node.js : [https://nodejs.org/](https://nodejs.org/)

#### 3. Open another CLI / shell, go into project root folder, then go into folder `/LyraGUI/`. And run below : 

`npm install`

`npm run dev`

open the URL on your CLI / shell.

after training, your model will be saved in `models/trained_color_model.jld2`

### Option 2. Batch Training ( Recommended )

modify `training_data_example_oklch.json` at project root

JSON fromat example is at below, here are 2 ways to build dataset : 

#### 1. OKLCH

```json

{
    "palettes": [
        [[0.92,0.141,252],[0.8,0.186,266],[0.9,0.117,256],[1,0.06,225],[0.8,0.186,266],[0.92,0.08,203],[1,0.079,153],[0.8,0.186,266],[0.91,0.096,242],[1,0.079,168]],
        [[0.92,0.141,276],[0.8,0.186,290],[0.94,0.067,265],[1,0.079,168],[0.8,0.186,290],[0.92,0.104,268],[1,0.079,204],[0.8,0.186,290],[0.95,0.211,279],[1,0.079,264]]
    ]
}

```

in project folder, command below

`julia --project=. scripts/build_data_batch_oklch.jl training_data_example_oklch.json`

OR

#### 2. HEX ( Legacy )

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

## Inspect Lyra Model Structure

To show Lyra Model Structure for AI Model Conversion, run below :

```shell
julia --project=. scripts/inspect_lyra_jld2.jl models/YourModel.jld2
```

## Project Detail / Debug

### Add Custom pkg :

Now /src/ folder have 2 customized pkg ( `LyraUtils` & `LyraDataTrain` ). To add new pkg, you need to run below at /src/ : 

`julia`

`] generate YourNewPkgName`

( all your jl codes needs to be `module` type )

### If your Custom pkg has new Dependencies :

If you add any new dependencies into your customized pkg's `project.toml`, you need to run below command on `every environment` which is using your customized pkg ( or it won't auto update )

`julia`

`] activate .`

`dev path/to/project_root/src/YourNewPkgName`

### Resolve pkg problems :

If your pkg problems still exist, try below command too : 

( it will check the package dependencies )

`julia`

`] activate .`

`resolve`

### Add new Controller & Resource to Genie

At LyraBackend ( Genie.jl ), if you want to create new Controller & Resource, run below at /LyraBackend/ : 

`julia --project=.`

`using Genie`

`Genie.Generator.newresource("TheName")`

## Project Dependencies Details

Lux.jl License : [https://github.com/LuxDL/Lux.jl/blob/main/LICENSE](https://github.com/LuxDL/Lux.jl/blob/main/LICENSE)
<br>

Genie.jl License : [https://github.com/GenieFramework/Genie.jl/blob/main/LICENSE.md](https://github.com/GenieFramework/Genie.jl/blob/main/LICENSE.md)
<br>

React License : [https://github.com/facebook/react/blob/main/LICENSE](https://github.com/facebook/react/blob/main/LICENSE)
<br>

UnoCSS License : [https://github.com/unocss/unocss/blob/main/LICENSE](https://github.com/unocss/unocss/blob/main/LICENSE)
<br>

Vite License : [https://github.com/vitejs/vite/blob/main/LICENSE](https://github.com/vitejs/vite/blob/main/LICENSE)