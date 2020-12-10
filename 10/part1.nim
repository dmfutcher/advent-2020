import strutils, sequtils, algorithm, sugar

proc getInput: seq[int] = 
    let lines = splitLines(readFile("input"))
    return sorted(lines.map(parseInt))

proc joltageJumps(adapters: seq[int]): (int, int) =
    let jumps = (0..(len(adapters) - 2)).toSeq.map(i => adapters[i+1] - adapters[i])
    return (jumps.filter(x => x == 1).len, jumps.filter(x => x == 3).len)

let inputAdapters = getInput()
let internalAdapter = inputAdapters[len(inputAdapters) - 1] + 3
let adapters = concat(@[0], getInput(), @[internalAdapter])
let jumps = joltageJumps(adapters)

echo "Answer: ", jumps[0] * jumps[1]

export getInput
