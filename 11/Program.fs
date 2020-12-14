open FSharp.Collections.ParallelSeq

type SeatGrid = {
    items: char list
    width: int
    height: int
}

let getInput = 
    System.IO.File.ReadAllLines "input"
        |> Array.map Seq.toList
        |> Seq.toList

let nextSeatVal current adjacent = 
    let occupiedAdjacent = (adjacent |> List.filter '#'.Equals).Length
    match current with
    | 'L' -> if occupiedAdjacent = 0 then '#' else 'L'
    | '#' -> if occupiedAdjacent >= 4 then 'L' else '#'
    | _ -> '.'

let nextSeatValPart2 current adjacent = 
    let occupiedAdjacent = (adjacent |> List.filter '#'.Equals).Length
    match current with
    | 'L' -> if occupiedAdjacent = 0 then '#' else 'L'
    | '#' -> if occupiedAdjacent >= 5 then 'L' else '#'
    | _ -> '.'

let inline toXY grid i =
    let y = i / grid.width
    let x = i % grid.width
    x, y

let inline toIndex grid xy =
    let (x, y) = xy
    y * grid.width + x

let adjacents grid i =
    let (x,y) = toXY grid i

    let positions = [
        x-1,y+1; x,y+1; x+1,y+1; x-1,y; 
        x+1,y; x-1,y-1; x,y-1; x+1,y-1
    ] 

    positions 
        |> List.filter (fun (x, y) -> x >= 0 && y >= 0 && x < grid.width && y < grid.height)
        |> List.map (fun pos -> grid.items.Item (toIndex grid pos))

let adjacentsPart2 grid i = 
    let rec directionIndices (prevX, prevY) (stepX, stepY) =
        let (x, y) = (prevX + stepX, prevY + stepY)
        if (x < 0 || y < 0 || x >= grid.width || y >= grid.height) 
            then []
            else 
                let c = grid.items.Item (toIndex grid (x, y))
                if (c.Equals('#') || c.Equals('L')) then [c] else c :: directionIndices (x, y) (stepX, stepY)

    let xy = toXY grid i
    let directions = [
        (-1, 0); (1, 0); (0, 1); (0, -1);
        (-1, 1); (-1, -1); (1, 1); (1, -1)
    ]

    directions |> List.map (fun step -> directionIndices xy step) |> List.concat
    
let nextGeneration grid adjacentFn nextSeatFn =
    let newItems = grid.items |> PSeq.mapi (fun i v -> nextSeatFn v (adjacentFn grid i)) |> PSeq.toList
    {items = newItems; width = grid.width; height = grid.height}

let rec findStableGeneration prev adjacentFn nextSeatFn =
    let next = nextGeneration prev adjacentFn nextSeatFn
    if next = prev then next else findStableGeneration next adjacentFn nextSeatFn

[<EntryPoint>]
let main argv =
    let input = getInput
    let width = input.[0].Length
    let height = input.Length
    let grid = {items = List.concat input; width = width; height = height}
    
    let part1Stable = findStableGeneration grid adjacents nextSeatVal
    printfn "Part 1: %A" (part1Stable.items |> List.filter '#'.Equals).Length

    let part2Stable = findStableGeneration grid adjacentsPart2 nextSeatValPart2
    printfn "Part 2: %A" (part2Stable.items |> List.filter '#'.Equals).Length

    0
