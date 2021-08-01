//
//  Puzzle03.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

import Foundation

fileprivate struct House: Hashable {
    var x, y: Int
}

struct Puzzle03: Puzzle {

    private let input: String

    init() {
        input = InputFileReader.read("Input03")[0]
    }

    func part1() {
        var current = House(x: 0, y: 0)
        var visited: Set<House> = [current]
        for c in input {
            switch c {
            case "<": current = House(x: current.x-1, y: current.y)
            case ">": current = House(x: current.x+1, y: current.y)
            case "^": current = House(x: current.x, y: current.y+1)
            case "v": current = House(x: current.x, y: current.y-1)
            default: break
            }
            visited.insert(current)
        }
        print(visited.count)
    }

    func part2() {
        let instructions = Array(input)
        let startHouse = House(x: 0, y: 0)
        var visited: Set<House> = [startHouse]
        let lock = NSLock()
        let group = DispatchGroup()

        func go(start: Int) {
            var current = startHouse
            for i in stride(from: start, to: instructions.count - 1, by: 2) {
                let char = instructions[i]
                switch char {
                case "<": current = House(x: current.x-1, y: current.y)
                case ">": current = House(x: current.x+1, y: current.y)
                case "^": current = House(x: current.x, y: current.y+1)
                case "v": current = House(x: current.x, y: current.y-1)
                default: break
                }
                lock.lock()
                visited.insert(current)
                lock.unlock()
            }
        }

        group.enter()
        DispatchQueue.global().async {
            go(start: 0)
            group.leave()
        }
        group.enter()
        DispatchQueue.global().async {
            go(start: 1)
            group.leave()
        }
        group.notify(queue: .main) {
            print(visited.count)
            exit(0)
        }
        dispatchMain()
    }
}
