//
//  Puzzle11.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

struct Puzzle11: Puzzle {

    private let input = "hxbxwxba"

    func part1() {
        print(nextValidPassword(input))
    }

    func part2() {
        print(nextValidPassword("hxbxxyzz"))
    }

    /// Next password without any validation rules.
    private func next(_ password: String) -> String {
        guard let lastChar = password.last, let lastCharAscii = lastChar.asciiValue else {
            return password
        }
        var nextAscii = lastCharAscii + 1
        if nextAscii == 91 {
            nextAscii = 65
            return next(String(password.dropLast())) + String(UnicodeScalar(nextAscii))
        }
        if nextAscii == 123 {
            nextAscii = 97
            return next(String(password.dropLast())) + String(UnicodeScalar(nextAscii))
        }
        return String(password.dropLast()) + String(UnicodeScalar(nextAscii))
    }

    /// Next password, considering the validation rules
    private func nextValidPassword(_ password: String) -> String {
        var current = next(password)
        while true {
            if isValid(current) {
                break
            }
            current = next(current)
        }
        return current
    }

    /// Whether the given password is valid or not
    private func isValid(_ s: String) -> Bool {
        if containsInvalidChars(s) {
            return false
        }
        if hasIncreasingStraight(s) && hasTwoPairs(s) {
            return true
        }
        return false
    }

    /// Whether the string has an increasing straight like abc, xyz etc.
    /// Chars can't have gaps. abd will return false
    private func hasIncreasingStraight(_ s: String) -> Bool {
        for window in s.windows(ofCount: 3) {
            let firstAscii = window.first!.asciiValue!
            let midAscii = window[window.index(after: window.startIndex)].asciiValue!
            let lastAscii = window.last!.asciiValue!
            if firstAscii < midAscii, midAscii < lastAscii {
                if midAscii - firstAscii == 1, lastAscii - midAscii == 1 {
                    return true
                }
            }
        }
        return false
    }

    /// Whether the string contains invalid chars i.e [i, o, l]
    private func containsInvalidChars(_ s: String) -> Bool {
        return s.first { c in c == "i" || c == "o" || c == "l" } != nil
    }

    /// Whether the string has two non overlapping pairs of same char. Eg -
    /// aabb is valid
    /// aaab is invalid
    /// aaaa is valid. There are three pairs, but two are non overlapping
    private func hasTwoPairs(_ s: String) -> Bool {
        var pairsCount = 0
        var usedIndices = Set<String.Index>()
        for currentIndex in s.indices.dropLast() {
            let nextIndex = s.index(after: currentIndex)
            let current = s[currentIndex]
            let next = s[nextIndex]
            if current == next {
                pairsCount += 1
                usedIndices.insert(currentIndex)
                usedIndices.insert(nextIndex)
                if pairsCount >= 2, usedIndices.count >= 4 {
                    return true
                }
            }
        }
        return false
    }
}
