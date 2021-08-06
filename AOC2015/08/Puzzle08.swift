//
//  Puzzle08.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

import Darwin

struct Puzzle08: Puzzle {

    private let input: [String]

    init() {
        input = InputFileReader.read("Input08")
    }

    func part1() {
        let answer = input.reduce(0) { acc, string in
            let rawCount = string.count
            let decodeCount = decode(string).count
            let diff = rawCount - decodeCount
            return acc + diff
        }
        print(answer)
    }

    func part2() {
        let answer = input.reduce(0) { acc, string in
            let rawCount = string.count
            let encodeCount = encode(string).count
            let diff = encodeCount - rawCount
            return acc + diff
        }
        print(answer)
    }

    private func decode(_ str: String) -> String {
        var parsed = ""
        var index = str.index(after: str.startIndex)
        while index != str.index(before: str.endIndex) {
            let current = str[index]
            if current == "\\" {
                let next = str[str.index(after: index)]
                if next == "\\" {
                    parsed.append("\\")
                    index = str.index(index, offsetBy: 2)
                } else if next == "\"" {
                    parsed.append("\"")
                    index = str.index(index, offsetBy: 2)
                } else if next == "x" {
                    let asciiValue = str[str.index(index, offsetBy: 2)...str.index(index, offsetBy: 3)]
                    let char = Character(UnicodeScalar(UInt32(asciiValue, radix: 16)!)!)
                    parsed.append(char)
                    index = str.index(index, offsetBy: 4)
                } else {
                    parsed.append(current)
                    index = str.index(index, offsetBy: 1)
                }
            } else {
                parsed.append(current)
                index = str.index(index, offsetBy: 1)
            }
        }
        return parsed
    }

    private func encode(_ str: String) -> String {
        var parsed = "\""
        var index = str.startIndex
        while index != str.endIndex {
            let current = str[index]
            if current == "\"" {
                parsed.append("\\\"")
            } else if current == "\\" {
                parsed.append("\\\\")
            } else {
                parsed.append(current)
            }
            index = str.index(after: index)
        }
        parsed.append("\"")
        return parsed
    }
}
