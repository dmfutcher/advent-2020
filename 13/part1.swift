import Foundation
import Darwin

func getInput() throws -> (Int?, [Int?]) {
    let fileURL = URL(fileURLWithPath: (NSString(string:"input").expandingTildeInPath ))
    if FileManager.default.fileExists(atPath: fileURL.path) {  }

    let text = try String(contentsOf: fileURL, encoding: .utf8)
    let chunks = text.split(separator: "\n")
    let timestamp = Int(chunks[0])
    let routes = chunks[1].split(separator: ",").filter({ $0 != "x" }).map({ Int($0) })

    return (timestamp, routes)
}

func generateBusTimes(_ routes: [Int?], targetTime: Int) -> [Int: Int] {

    func generateRouteTimes(_ route: Int) -> Int {
        var i = 0
        var last = 0
        var times = [Int]()

        repeat {
            last = i * route
            times.append(last)
            i += 1
        } while last < targetTime

        return last
    }

    var routeTimes = [Int: Int]()
    for route in routes {
        if let r = route {
            routeTimes[r] = generateRouteTimes(r)
        }
    }

    return routeTimes
}

let (timestamp, routes) = try getInput()
if let earliestDeparture = timestamp { 
    let times = generateBusTimes(routes, targetTime: earliestDeparture)
    var earliest = Int.max
    var earliestKey = 0

    for k in times.keys {
        if let time = times[k] {
            if time < earliest {
                earliest = time
                earliestKey = k
            }
        }
    }

    let waitTime = earliest - earliestDeparture
    print(waitTime * earliestKey)
}



