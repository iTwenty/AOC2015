//
//  Puzzle16.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

struct Puzzle16: Puzzle {
    private let detectedCompounds = ["children": 3,
                                     "cats": 7,
                                     "samoyeds": 2,
                                     "pomeranians": 3,
                                     "akitas": 0,
                                     "vizslas": 0,
                                     "goldfish": 5,
                                     "trees": 3,
                                     "cars": 2,
                                     "perfumes": 1]

    private var allCompounds = [[String: Int]]()

    init() {
        InputFileReader.read("Input16").forEach { line in
            let str = line.replacingOccurrences(of: ",", with: ":").components(separatedBy: ": ").dropFirst()
            var compounds = [String: Int]()
            for index in stride(from: str.startIndex, to: str.endIndex, by: 2) {
                let compoundName = String(str[index])
                let compoundValue = Int(str[index+1])!
                compounds[compoundName] = compoundValue
            }
            allCompounds.append(compounds)
        }
    }

    func part1() {
        let auntNumber = allCompounds.indices.filter { matches(allCompounds[$0]) }[0] + 1
        print(auntNumber)
    }

    func part2() {
        let auntNumber = allCompounds.indices.filter { matches2(allCompounds[$0]) }[0] + 1
        print(auntNumber)
    }

    private func matches(_ compounds: [String: Int]) -> Bool {
        compounds.allSatisfy { $1 == detectedCompounds[$0]! }
    }

    private func matches2(_ compounds: [String: Int]) -> Bool {
        compounds.allSatisfy { (name: String, count: Int) in
            if name == "cats" || name == "trees" {
                return count >= detectedCompounds[name]!
            }
            if name == "pomeranians" || name == "goldfish" {
                return count <= detectedCompounds[name]!
            }
            return count == detectedCompounds[name]
        }
    }
}
