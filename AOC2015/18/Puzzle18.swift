//
//  Puzzle18.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

struct Puzzle18: Puzzle {
    private let lights: [[Character]]

    init() {
        lights = InputFileReader.read("Input18").map(Array.init)
    }

    func part1() {
        var lights = lights
        for _ in (0..<100) {
            lights = next(lights)
        }
        print(onCount(lights: lights))
    }

    func part2() {
        var lights = lights
        // Turn on 4 four corner lights
        lights[0][0] = "#"
        lights[0][99] = "#"
        lights[99][0] = "#"
        lights[99][99] = "#"
        for _ in (0..<100) {
            lights = next(lights, stuckCorners: true)
        }
        print(onCount(lights: lights))
    }

    private func next(_ lights: [[Character]], stuckCorners: Bool = false) -> [[Character]] {
        var newLights = lights
        for (yIndex, row) in lights.enumerated() {
            for (xIndex, light) in row.enumerated() {
                var isCorner = false // Will only be used is stuckCorners is true i.e part 2
                if stuckCorners {
                    if xIndex == 0 || xIndex == 99 {
                        if yIndex == 0 || yIndex == 99 {
                            isCorner = true
                        }
                    }
                }
                // Don't touch corner lights
                if !isCorner {
                    let on = onNeighbours((xIndex, yIndex), lights: lights)
                    if light == "#", !(on == 2 || on == 3) {
                        newLights[yIndex][xIndex] = "."
                    }
                    if light == ".", on == 3 {
                        newLights[yIndex][xIndex] = "#"
                    }
                }
            }
        }
        return newLights
    }

    private func onNeighbours(_ light: (xIndex: Int, yIndex: Int), lights: [[Character]]) -> Int {
        var on = 0
        for x in (light.xIndex-1...light.xIndex+1) {
            for y in (light.yIndex-1...light.yIndex+1) {
                if x == light.xIndex, y == light.yIndex { continue }
                if lights.indices.contains(x), lights.indices.contains(y) {
                    let state = lights[y][x]
                    if state == "#" {
                        on += 1
                    }
                }
            }
        }
        return on
    }

    private func onCount(lights: [[Character]]) -> Int {
        lights.flatMap { row in
            row.filter { $0 == "#" }
        }.count
    }
}
