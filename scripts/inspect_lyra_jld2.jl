using JLD2

shape_str(x) = x isa AbstractArray ? string(size(x)) : "-"
etype_str(x) = x isa AbstractArray ? string(eltype(x)) : "-"

function print_fields(obj; prefix = "")
    if obj isa NamedTuple
        names = propertynames(obj)
        for name in names
            v = getproperty(obj, name)
            println(prefix, name, " :: ", typeof(v), "  shape=", shape_str(v), "  eltype=", etype_str(v))
        end
        return collect(names)
    end

    names = fieldnames(typeof(obj))
    for name in names
        v = getfield(obj, name)
        println(prefix, name, " :: ", typeof(v), "  shape=", shape_str(v), "  eltype=", etype_str(v))
    end
    return collect(names)
end

function node_fieldnames(obj)::Vector{Symbol}
    if obj isa NamedTuple
        return collect(propertynames(obj))
    end
    return collect(fieldnames(typeof(obj)))
end

function compat_note(ps)
    need_layers = (:layer_1, :layer_2, :layer_3, :layer_4)
    got_layers = Set(node_fieldnames(ps))
    missing_layers = [x for x in need_layers if !(x in got_layers)]

    println("⭐ ||||||  converter_compat  |||||| ⭐")
    if !isempty(missing_layers)
        println("status: FAIL")
        println("missing layers: ", missing_layers)
        return
    end

    l2 = getproperty(ps, :layer_2)
    l2_fields = Set(node_fieldnames(l2))
    has_l2_scale = (:scale in l2_fields) || (:weight in l2_fields) || (:gamma in l2_fields)
    has_l2_bias = (:bias in l2_fields) || (:beta in l2_fields) || (:shift in l2_fields)

    println("status: ", (has_l2_scale && has_l2_bias) ? "OK" : "CHECK")
    println("layer_2 fields: ", collect(l2_fields))
    if !(has_l2_scale && has_l2_bias)
        println("note: layer_2 is missing recognized affine fields")
    end
end

function inspect_file(model_path::String)
    if !isfile(model_path)
        error("Model file not found: $model_path")
    end

    jldopen(model_path, "r") do f
        println("⭐ ||||||  file_keys  |||||| ⭐")
        println(collect(keys(f)))
    end

    @load model_path tstate

    println("⭐ ||||||  file  |||||| ⭐")
    println(model_path)
    println()

    #=
    The commented parts are usually not needed
    And will contain large blocks of text
    Uncomment them if you need them
    =#
    println("⭐ ||||||  tstate  |||||| ⭐")
    #println("type: ", typeof(tstate))
    #println("fields: ", collect(fieldnames(typeof(tstate))))
    if hasproperty(tstate, :model)
        #println("model type: ", typeof(getproperty(tstate, :model)))
    end
    if hasproperty(tstate, :parameters)
        println("parameters type: ", typeof(getproperty(tstate, :parameters)))
    end
    if hasproperty(tstate, :states)
        println("states type: ", typeof(getproperty(tstate, :states)))
    end
    println()

    if !hasproperty(tstate, :parameters)
        println("No :parameters found in tstate.")
        return
    end

    ps = getproperty(tstate, :parameters)

    println("⭐ ||||||  parameters  |||||| ⭐")
    print_fields(ps)
    println()

    for lname in node_fieldnames(ps)
        layer = getproperty(ps, lname)
        println("⭐ ||||||  ", lname, "  |||||| ⭐")
        println("type: ", typeof(layer))
        names = print_fields(layer; prefix = "  ")
        if isempty(names)
            println("  (no fields)")
        end
        println()
    end

    compat_note(ps)
end

#=
Example Command : 
julia --project=. scripts/inspect_lyra_jld2.jl models/Lyra2.0.jld2
=#
function main()
    model_path = ARGS[1] # e.g. "models/Lyra2.0.jld2"
    inspect_file(model_path)
end

main()
