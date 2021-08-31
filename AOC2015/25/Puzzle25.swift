//
//  Puzzle25.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

fileprivate typealias Position = (row: Int, col: Int)

struct Puzzle25: Puzzle {
    private let targetPosition = (2947, 3029)

    func part1() {
        let targetIndex = index(forPosition: targetPosition)
        var code = 20151125
        for _ in 2...targetIndex {
            code = nextCode(code)
        }
        print(code)
    }

    func part2() {
        // Ooooweeee!
    }

    private func nextCode(_ current: Int) -> Int {
        (current * 252533) % 33554393
    }

    private func index(forPosition position: Position) -> Int {
        let diagonal = position.row + position.col - 1
        let diagonalEndIndex = diagonal * (diagonal + 1) / 2
        let diagonalStartIndex = diagonalEndIndex - diagonal + 1
        let index = diagonalStartIndex + (diagonal - position.row)
        return index
    }
}
