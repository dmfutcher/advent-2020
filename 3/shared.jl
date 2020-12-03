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

function map_walk(map, step_x, step_y)
    tree_count = 0
    x = 1
    y = 1

    while y <= length(map)
        if map[y][x] == '#'
            tree_count += 1
        end

        x += step_x
        y += step_y
    end

    tree_count
end
