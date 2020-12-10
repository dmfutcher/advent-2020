import strutils, sequtils, algorithm, sugar

proc getInput: seq[int] = 
    let lines = splitLines(readFile("input"))
    let adapters = sorted(lines.map(parseInt))
    let internalAdapter = adapters[len(adapters) - 1] + 3
    return concat(@[0], adapters, @[internalAdapter])
 
proc joltageJumps(adapters: seq[int]): (int, int) =
    let jumps = (0..(len(adapters) - 2)).toSeq.map(i => adapters[i+1] - adapters[i])
    return (jumps.filter(x => x == 1).len, jumps.filter(x => x == 3).len)

let adapters = getInput()
let jumps = joltageJumps(adapters)

echo "Answer: ", jumps[0] * jumps[1]
