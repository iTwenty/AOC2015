//
//  Puzzle13.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

import Foundation

struct Puzzle13: Puzzle {

    private var scores = [Set<String>: Int]()
    private var people = Set<String>()

    init() {
        let pattern = #"(?<p1>.+) would (?<sign>gain|lose) (?<amount>[0-9]+) happiness units by sitting next to (?<p2>.+)."#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        InputFileReader.read("Input13").forEach { line in
            let range = NSRange(line.startIndex..<line.endIndex, in: line)
            let matches = regex.matches(in: line, options: [], range: range)
            for match in matches {
                let p1Range = Range(match.range(withName: "p1"), in: line)!
                let p2Range = Range(match.range(withName: "p2"), in: line)!
                let p1 = String(line[p1Range])
                let p2 = String(line[p2Range])
                let signRange = Range(match.range(withName: "sign"), in: line)!
                let scoreRange = Range(match.range(withName: "amount"), in: line)!
                var score = Int(line[scoreRange])!
                if line[signRange] == "lose" {
                    score.negate()
                }
                people.insert(p1)
                people.insert(p2)
                scores[[p1, p2], default: 0] += score
            }
        }
    }

    func part1() {
        print(maxHappinessScore(people: people, scores: scores))
    }

    func part2() {
        var peopleIncludingMe = people
        peopleIncludingMe.insert("Me")
        print(maxHappinessScore(people: peopleIncludingMe, scores: scores))
    }

    private func maxHappinessScore(people: Set<String>, scores: [Set<String>: Int]) -> Int {
        var maxScore = Int.min
        for seating in people.permutations() {
            var currentSeatingScore = 0
            for (index, person) in seating.enumerated().dropLast() {
                if index == 0 {
                    let previousIndex = seating.count - 1
                    let previousPerson = seating[previousIndex]
                    currentSeatingScore += scores[[person, previousPerson], default: 0]
                }
                let nextIndex = index + 1
                let nextPerson = seating[nextIndex]
                currentSeatingScore += scores[[person, nextPerson], default: 0]
            }
            maxScore = max(maxScore, currentSeatingScore)
        }
        return maxScore
    }
}
