include("shared.jl")

const slopes = [
    [1, 1],
    [3, 1],
    [5, 1],
    [7, 1],
    [1, 2]
]

map = load_map()
tree_counts = Vector{Int}()

for slope in slopes
    right = slope[1]
    down = slope[2]
    
    push!(tree_counts, map_walk(map, right, down))
end

println("Answer: ", foldl(*, tree_counts))
