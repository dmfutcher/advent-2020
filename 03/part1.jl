include("shared.jl")

map = load_map()
trees = map_walk(map, 3, 1)
println("Answer: ", trees, " trees")
