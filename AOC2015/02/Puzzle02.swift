//
//  Puzzle02.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

fileprivate typealias Dimensions = (l: Int, w: Int, h: Int)

struct Puzzle02: Puzzle {

    private let input: [Dimensions]

    init() {
        input = InputFileReader.read("Input02").map({ line in
            let ss = line.split(separator: "x")
            return (Int(ss[0])!, Int(ss[1])!, Int(ss[2])!)
        })
    }

    func part1() {
        let answer = input.reduce(0) { acc, d in
            acc + paperArea(for: d)
        }
        print(answer)
    }

    func part2() {
        let answer = input.reduce(0) { acc, d in
            acc + ribbonLength(for: d)
        }
        print(answer)
    }

    private func paperArea(for d: Dimensions) -> Int {
        let lw = d.l*d.w
        let wh = d.w*d.h
        let hl = d.h*d.l
        let slack = [lw, wh, hl].sorted()[0]
        return 2*lw + 2*wh + 2*hl + slack
    }

    private func ribbonLength(for d: Dimensions) -> Int {
        let twoSmallestSides = [d.l, d.w, d.h].sorted().dropLast()
        let perimeter = 2 * (twoSmallestSides[0] + twoSmallestSides[1])
        let ribbon = d.l * d.w * d.h
        return perimeter + ribbon
    }
}
