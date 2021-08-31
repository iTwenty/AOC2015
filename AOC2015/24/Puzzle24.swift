//
//  Puzzle24.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

struct Puzzle24: Puzzle {
    private let weights: [Int]

    init() {
        weights = InputFileReader.read("Input24").compactMap(Int.init)
    }

    func part1() {
        let splitWeight = weights.reduce(0, +) / 3
        for i in 6..<weights.count - 6 {
            let minQe = weights.combinations(ofCount: i).lazy
                .filter { $0.reduce(0, +) == splitWeight }
                .compactMap { $0.reduce(1, *) }
                .first { _ in true }
            print(minQe!)
            break
        }
    }

    func part2() {
        let splitWeight = weights.reduce(0, +) / 4
        for i in 5..<weights.count - 5 {
            let minQe = weights.combinations(ofCount: i).lazy
                .filter { $0.reduce(0, +) == splitWeight }
                .compactMap { $0.reduce(1, *) }
                .first { _ in true }
            print(minQe!)
            break
        }
    }
}
