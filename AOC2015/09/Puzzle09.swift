//
//  Puzzle09.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

import Algorithms

// Basically a traveling salesman problem. Used brute force since number of cities is "only" 8.
struct Puzzle09: Puzzle {
    private var locations: [String]
    private var distances: [Set<String>: Int]

    init() {
        distances = [:]
        locations = []
        var seen = Set<String>()
        InputFileReader.read("Input09").forEach { line in
            var split = line.components(separatedBy: " = ")
            let distance = Int(split[1])!
            split = split[0].components(separatedBy: " to ")
            let locationA = split[0]
            let locationB = split[1]
            if !seen.contains(locationA) {
                seen.insert(locationA)
                locations.append(locationA)
            }
            if !seen.contains(locationB) {
                seen.insert(locationB)
                locations.append(locationB)
            }
            distances[[locationA, locationB]] = distance
        }
    }

    func part1() {
        var currentMin = Int.max
        locations.permutations().forEach { locs in
            var currentDistance = 0
            for pair in locs.adjacentPairs() {
                currentDistance += (distances[[pair.0, pair.1], default: 0])
            }
            currentMin = min(currentMin, currentDistance)
        }
        print(currentMin)
    }

    func part2() {
        var currentMax = Int.min
        locations.permutations().forEach { locs in
            var currentDistance = 0
            for (index, current) in locs.enumerated().dropLast() {
                let next = locs[index + 1]
                currentDistance += (distances[[current, next], default: 0])
            }
            currentMax = max(currentMax, currentDistance)
        }
        print(currentMax)
    }
}
