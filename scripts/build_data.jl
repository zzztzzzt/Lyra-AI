using LyraDataTrain.PaletteProcessor

function prompt_palette(n::Int)
    while true
        println("Paste all hex colors at once? (y/n)")
        print("> ")
        mode = lowercase(strip(readline()))

        if mode == "y"
            println("Paste exactly $n hex colors (space or comma separated):")
            print("> ")
            line = readline()

            hexes = split(line, r"[,\s]+"; keepempty=false)
            hexes = String.(hexes) # SubString → String
            hexes = replace.(hexes, "\"" => "", "'" => "")

            if length(hexes) != n
                println("Error: You must provide exactly $n hex colors, but got $(length(hexes)).")
                println("Please try again.\n")
                continue
            end

            return hexes

        elseif mode == "n"
            hexes = String[]
            for i in 1:n
                print("please enter $i / $n Hex color: ")
                input = strip(readline())
                clean_hex = replace(input, ('"' => ""), ("'" => ""))
                push!(hexes, clean_hex)
            end
            return hexes

        else
            println("Invalid input. Please enter 'y' or 'n'.\n")
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    hex_list = prompt_palette(7)
    save_augmented_palette("training_data/color_data.jld2", hex_list)
end

# Example Usage ( Demonstration purposes only. For formal training, please use our GUI or Batch Training )
#=
my_palette = [
    "#ABE7FF", # main color
    "#DAF0F9", "#F4F9FF",  # gradient 1
    "#425573", "#CCCCCC",  # gradient 2
    "#8C939F", "#D6EFFF"   # gradient 3
]

save_augmented_palette("../training_data/color_data.jld2", my_palette)
=#