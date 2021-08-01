//
//  Puzzle01.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

struct Puzzle01: Puzzle {

    private let input: String

    init() {
        input = InputFileReader.read("Input01")[0]
    }

    func part1() {
        let answer = input.reduce(into: 0) { floor, c in
            if c == "(" {
                floor += 1
            }
            if c == ")" {
                floor -= 1
            }
        }
        print(answer)
    }

    func part2() {
        var answer = 0
        var floor = 0
        for (index, c) in input.enumerated() {
            if c == "(" {
                floor += 1
            }
            if c == ")" {
                floor -= 1
                if floor == -1 {
                    answer = (index + 1)
                    break
                }
            }
        }
        print(answer)
    }
}
