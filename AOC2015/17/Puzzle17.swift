//
//  Puzzle17.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

import Foundation

struct Puzzle17: Puzzle {

    private let containers: [Int]

    init() {
        containers = InputFileReader.read("Input17").compactMap(Int.init)
    }

    func part1() {
        var combinations = 0
        var minContainers = Int.max
        for i in (0..<Int(pow(Double(2), Double(containers.count)))) {
            let binary = Array(String(i, radix: 2).pad(with: "0", toSize: containers.count))
            let oneIndices = binary.indices.filter { binary[$0] == "1" }
            var sum = 0
            for index in oneIndices {
                sum += containers[index]
            }
            if sum == 150 {
                combinations += 1
                minContainers = min(minContainers, oneIndices.count)
            }
        }
        print(combinations)
        print(minContainers)
    }

    func part2() {
        // TADA!! Solved in Part 1.
    }
}
