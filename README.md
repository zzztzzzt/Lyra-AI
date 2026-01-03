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
        {
            "name": "light green",
            "colors": ["#86FFB1", "#ADF2D1", "#006D1D", "#E0FFD7", "#79FF94", "#3FFFBF", "#BDFFD4"]
        },
        {
            "name": "yellow",
            "colors": ["#FFED86", "#F9F3DA", "#FFFDF4", "#F9FF55", "#E0E0E0", "#FFF1DA", "#FFFCD6"]
        }
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

`#86DDFF #DAF0F9 #F4F9FF #425573 #CCCCCC #8C939F #D6EFFF`

or

`"#86DDFF", "#DAF0F9", "#F4F9FF", "#425573", "#CCCCCC", "#8C939F", "#D6EFFF"`

if you choose " input one color everytime ", you can type in below format

`#86DDFF` or `"#86DDFF"`

after the dataset is enough, run training code

`julia --project=. scripts/train.jl`

your model will be saved in `models/trained_color_model.jld2`