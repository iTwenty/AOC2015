//
//  Puzzle14.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

import Foundation

fileprivate struct DeerInfo {
    let speed, flyDuration, restDuration: Int
}

struct Puzzle14: Puzzle {

    private var deerInfos = [String: DeerInfo]()

    init() {
        let pattern = #"(?<name>.+) can fly (?<speed>[0-9]+) km\/s for (?<flyDuration>[0-9]+) seconds, but then must rest for (?<restDuration>[0-9]+) seconds."#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        InputFileReader.read("Input14").forEach { line in
            let range = NSRange(line.startIndex..<line.endIndex, in: line)
            let matches = regex.matches(in: line, options: [], range: range)
            for match in matches {
                let nameRange = Range(match.range(withName: "name"), in: line)!
                let name = String(line[nameRange])
                let speedRange = Range(match.range(withName: "speed"), in: line)!
                let speed = Int(line[speedRange])!
                let flyDurationRange = Range(match.range(withName: "flyDuration"), in: line)!
                let flyDuration = Int(line[flyDurationRange])!
                let restDurationRange = Range(match.range(withName: "restDuration"), in: line)!
                let restDuration = Int(line[restDurationRange])!
                deerInfos[name] = DeerInfo(speed: speed, flyDuration: flyDuration, restDuration: restDuration)
            }
        }
    }

    func part1() {
        let maxDistance = deerInfos.values.map { info in
            calculateDistance(deerInfo: info, atTime: 2503)
        }.max()
        print(maxDistance ?? -1)
    }

    func part2() {
        var points = [String: Int]()
        for time in 0...2503 {
            let distancesAtTime = deerInfos.mapValues { info in
                calculateDistance(deerInfo: info, atTime: time)
            }
            let maxDistanceDeerName = distancesAtTime.max { $0.value < $1.value }!.key
            points[maxDistanceDeerName, default: 0] += 1
        }
        print(points.values.max() ?? -1)
    }

    private func calculateDistance(deerInfo: DeerInfo, atTime time: Int) -> Int {
        let cycleDuration = deerInfo.flyDuration + deerInfo.restDuration
        let cyclesCount = time / cycleDuration
        let remainder = time % cycleDuration
        return cyclesCount * (deerInfo.speed * deerInfo.flyDuration) + (min(deerInfo.flyDuration, remainder) * deerInfo.speed)
    }
}
