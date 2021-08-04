//
//  Puzzle05.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

struct Puzzle05: Puzzle {

    private let words: [String]

    init() {
        words = InputFileReader.read("Input05")
    }

    func part1() {
        print(words.filter(isNice).count)
    }

    func part2() {
        print(words.filter(isNice2).count)
    }

    private func isNice(_ word: String) -> Bool {
        if ["ab", "cd", "xy", "pq"].contains(where: { str in word.contains(str) }) {
            return false
        }
        if !containsRepeatedChars(word) {
            return false
        }
        if !containsThreeOrMoreVowels(word) {
            return false
        }
        return true
    }

    private func isNice2(_ word: String) -> Bool {
        if !containsPairWithoutOverlap(word) {
            return false
        }
        if !containsRepeatingCharWithOneCharInBetween(word) {
            return false
        }
        return true
    }

    private func containsRepeatedChars(_ word: String) -> Bool {
        for i in word.indices.dropLast() {
            let current = word[i]
            let next = word[word.index(after: i)]
            if current == next {
                return true
            }
        }
        return false
    }

    private func containsThreeOrMoreVowels(_ word: String) -> Bool {
        let chars = Array(word)
        let vowels = Set("aeiou")
        return chars.filter { vowels.contains($0) }.count >= 3
    }

    private func containsPairWithoutOverlap(_ word: String) -> Bool {
        var map = [String: Set<String.Index>]()
        for i in word.indices.dropLast() {
            let nxt = word.index(after: i)
            let key = "\(word[i])\(word[nxt])"
            var value = map[key, default: []]
            value.insert(i)
            value.insert(nxt)
            map[key] = value
        }
        return !map.values.filter { $0.count > 3 }.isEmpty
    }

    private func containsRepeatingCharWithOneCharInBetween(_ word: String) -> Bool {
        for i in word.indices.dropLast(2) {
            let char = word[i]
            let toCheck = word[word.index(i, offsetBy: 2)]
            if char == toCheck {
                return true
            }
        }
        return false
    }
}
