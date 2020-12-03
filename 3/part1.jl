const map_extend_factor = 200

function load_map()
    map = Vector{String}()

    open("input") do f
        for line in eachline(f)
            push!(map, repeat(line, map_extend_factor))
        end
    end

    map
end

function map_walk(map, step_right, step_down)
    tree_count = 0
    x = 1
    y = 1
    max_y = length(map)

    while y <= length(map)
        if map[y][x] == '#'
            tree_count += 1
        end

        x += step_right
        y += step_down
    end

    tree_count
end

map = load_map()
trees = map_walk(map, 3, 1)
println("Aswer: ", trees, " trees")
