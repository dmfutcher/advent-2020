import Foundation
import Darwin

func getInput() throws -> ([(Int, Int)]) {
    let fileURL = URL(fileURLWithPath: (NSString(string:"input").expandingTildeInPath ))

    let text = try String(contentsOf: fileURL, encoding: .utf8)
    let chunks = text.split(separator: "\n")
    return chunks[1].split(separator: ",").enumerated().compactMap {
                                                    guard let i = Int($1) else { return nil }
                                                    return (i, $0) }
                                                .map { (m, v: Int) in (m, (-v).mod(m)) }
}

extension Int {
    func mod(_ modulus: Int) -> Int {
        let m = self % modulus
        return m < 0 ? m + modulus : m
    }

    func inverseMod(_ modulus: Int) -> Int? {
        var isEven = true
        var inv = 1, gcd = self, v1 = 0, v3 = modulus
        
        while v3 != 0 {
            (inv, v1, gcd, v3) = (v1, inv + gcd / v3 * v1, v3, gcd % v3)
            isEven = !isEven
        }

        return isEven ? inv : modulus - inv
    }
}

func chineseRemainder(_ mas: [(Int, Int)]) -> Int {
  let m = mas.lazy.map(\.0).reduce(1, *)
  let was = mas.map { (mod, ai) -> (Int, Int) in
    let zi = m / mod
    guard let yi = zi.inverseMod(mod) else { return (0, 0) }
    return ((yi * zi) % m, ai)
  }

  return was.reduce(0, { ($0 + ($1.0 * $1.1)) % m })
}

let routes = try getInput()
print("Part Two: ", chineseRemainder(routes))
