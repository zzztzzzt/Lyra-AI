# Lyra

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

### Option 2. Batch Training

[ wip ]

### Option 3. CLI / Shell command ( Demonstration purposes only. For formal training, please use our GUI or Batch Training )

in project folder, command below

```shell

julia --project=. build_data.jl

```

if you choose "input all in once", you can type in below format

```shell

#86DDFF #DAF0F9 #F4F9FF #425573 #CCCCCC #8C939F #D6EFFF

```
or
```shell

"#86DDFF", "#DAF0F9", "#F4F9FF", "#425573", "#CCCCCC", "#8C939F", "#D6EFFF"

```

if you choose "input one color everytime", you can type in below format

```shell

#86DDFF

```
or
```shell

"#86DDFF"

```