from part1 import getInput
import sequtils, tables

let inputAdapters = getInput()
let internalAdapter = inputAdapters[len(inputAdapters) - 1] + 3
let adapters = concat(inputAdapters, @[internalAdapter])

var combinations = {0: 1}.toTable

for a in adapters:
    combinations[a] = combinations.getOrDefault(a - 1, 0) + combinations.getOrDefault(a - 2, 0) + combinations.getOrDefault(a - 3, 0)

echo "Answer: ", combinations[adapters[len(adapters) - 1]]
