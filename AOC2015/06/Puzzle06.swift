//
//  Puzzle06.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

fileprivate typealias Position = (x: Int, y: Int)

fileprivate enum Action {
    case on, off, toggle
}

fileprivate struct Instruction {
    let action: Action
    let start: Position
    let end: Position
}

struct Puzzle06: Puzzle {

    private let input: [Instruction]

    init() {
        input = InputFileReader.read("Input06").map { line -> Instruction in
            let split = line.split(separator: " ")
            let startIndex = (split.count == 4 ? 1 : 2)
            let endIndex = startIndex + 2
            let startStr = split[startIndex].split(separator: ",")
            let start = (Int(startStr.first!)!, Int(startStr.last!)!)
            let endStr = split[endIndex].split(separator: ",")
            let end = (Int(endStr.first!)!, Int(endStr.last!)!)
            if split.count == 4 {
                return Instruction(action: .toggle, start: start, end: end)
            } else if split[1] == "on" {
                return Instruction(action: .on, start: start, end: end)
            } else {
                return Instruction(action: .off, start: start, end: end)
            }
        }
    }

    func part1() {
        var lights = Array(repeating: Array(repeating: false, count: 1000), count: 1000)
        input.forEach { instruction in
            for y in (instruction.start.y...instruction.end.y) {
                for x in (instruction.start.x...instruction.end.x) {
                    switch instruction.action {
                    case .on: lights[y][x] = true
                    case .off: lights[y][x] = false
                    case .toggle: lights[y][x].toggle()
                    }
                }
            }
        }

        let ans = lights.flatMap { $0 }.filter { $0 }.count
        print(ans)
    }

    func part2() {
        var lights = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
        input.forEach { instruction in
            for y in (instruction.start.y...instruction.end.y) {
                for x in (instruction.start.x...instruction.end.x) {
                    switch instruction.action {
                    case .on: lights[y][x] += 1
                    case .off: lights[y][x] = max(lights[y][x] - 1, 0)
                    case .toggle: lights[y][x] += 2
                    }
                }
            }
        }

        let ans = lights.flatMap { $0 }.reduce(0, +)
        print(ans)
    }
}
