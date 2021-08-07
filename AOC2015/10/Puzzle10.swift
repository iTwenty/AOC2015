//
//  Puzzle10.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

struct Puzzle10: Puzzle {

    private let input = "1113122113"

    func part1() {
        print(lookAndSay(start: input, count: 40).count)
    }

    func part2() {
        print(lookAndSay(start: input, count: 50).count)
    }

    private func lookAndSay(start: String, count: Int) -> String {
        var current = start
        for _ in (0..<count) {
            let chunked = current.chunked { $0 == $1 }
            var new = ""
            chunked.forEach { str in
                let count = str.count
                let char = str.first!
                new.append("\(count)\(char)")
            }
            current = new
        }
        return current
    }
}
