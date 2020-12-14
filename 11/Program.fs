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
    
let nextGeneration grid =
    let newItems = grid.items |> PSeq.mapi (fun i v -> nextSeatVal v (adjacents grid i)) |> PSeq.toList
    {items = newItems; width = grid.width; height = grid.height}
    
let printGrid grid = 
    grid.items |> List.chunkBySize grid.width |> List.iter (fun l -> printfn "%A" (l |> Array.ofList |> System.String.Concat))
    printfn "%A" "\n"

let rec findStableGeneration prev =
    let next = nextGeneration prev
    if next = prev then next else findStableGeneration next

[<EntryPoint>]
let main argv =
    let input = getInput
    let width = input.[0].Length
    let height = input.Length
    let grid = {items = List.concat input; width = width; height = height}
    
    let next = findStableGeneration grid
    printfn "Part 1: %A" (next.items |> List.filter '#'.Equals).Length

    0