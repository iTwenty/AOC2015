//
//  Puzzle19.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

struct Puzzle19: Puzzle {
    private var replacements = [String: Set<String>]()
    private var medicine: String = ""

    init() {
        InputFileReader.read("Input19").forEach { line in
            let split = line.components(separatedBy: " => ")
            if split.count == 2 {
                let key = split[0]
                let value = split[1]
                if var existing = replacements[key] {
                    existing.insert(value)
                    replacements[key] = existing
                } else {
                    replacements[key] = [value]
                }
            } else {
                medicine = split[0]
            }
        }
    }

    func part1() {
        // We rely on follwing assumptions.
        // 1. Molecule names are either a single capital char e.g P, O etc
        // OR
        // 2. Molecule names are single capital char followed by single small char. e.g Mg, Ti
        // This assumption breaks for the special molecule e, but medicine doesn't contain e. so...
        var all = Set<String>()
        var currentIndex = medicine.startIndex
        while currentIndex != medicine.endIndex {
            var replaceRange = currentIndex...currentIndex
            let currentChar = medicine[currentIndex]
            if currentChar.isUppercase {
                // Current char is uppercase. Need to read next char, if within bounds, to determine
                // full molecule name
                let nextIndex = medicine.index(after: currentIndex)
                if nextIndex == medicine.endIndex {
                    // End of string. Last char was uppercase, and therefore a complete molecule
                    molecules(afterReplacing: replaceRange).forEach { all.insert($0) }
                    currentIndex = medicine.index(after: currentIndex)
                } else {
                    let nextChar = medicine[nextIndex]
                    if nextChar.isLowercase {
                        // next char is lowercase. Need to consider current and next together for
                        // complete molecule name
                        replaceRange = currentIndex...nextIndex
                        molecules(afterReplacing: replaceRange).forEach { all.insert($0) }
                        currentIndex = medicine.index(after: nextIndex)
                    } else {
                        // Next char is uppercase. Consider only current char as molecule. Next char
                        // will be handled in next iteration of while loop
                        molecules(afterReplacing: replaceRange).forEach { all.insert($0) }
                        currentIndex = medicine.index(after: currentIndex)
                    }
                }
            } else {
                // Current char is lowercase. It has already been handled inside. Just increase index
                currentIndex = medicine.index(after: currentIndex)
            }
        }
        print(all.count)
    }

    func part2() {

    }

    private func molecules(afterReplacing range: ClosedRange<String.Index>) -> [String] {
        let key = String(medicine[range])
        var ret = [String]()
        if let values = replacements[key] {
            values.forEach { value in
                var new = medicine
                new.replaceSubrange(range, with: value)
                ret.append(new)
            }
        }
        return ret
    }
}
