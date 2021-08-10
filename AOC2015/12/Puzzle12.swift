//
//  Puzzle12.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

import Foundation

struct Puzzle12: Puzzle {
    private let json: [String: Any]

    init() {
        let inputData = InputFileReader.read("Input12")[0].data(using: .utf8)!
        json = try! JSONSerialization.jsonObject(with: inputData, options: []) as! [String: Any]
    }

    func part1() {
        var sum = 0
        walk(start: json) { node in
            if let number = node as? Int {
                sum += number
            }
        }
        print(sum)
    }

    func part2() {
        var sum = 0
        walk(start: json, ignoreValue: "red") { node in
            if let number = node as? Int {
                sum += number
            }
        }
        print(sum)
    }

    private func walk(start: Any, ignoreValue: String? = nil, action: (Any) -> ()) {
        if let dict = start as? [String: Any] {
            if let ignore = ignoreValue {
                var containsIgnoreValue = false
                for value in dict.values {
                    if let valueStr = value as? String, valueStr == ignore {
                        containsIgnoreValue = true
                        break
                    }
                }
                if !containsIgnoreValue {
                    dict.values.forEach { walk(start: $0, ignoreValue: ignoreValue, action: action) }
                }
            } else {
                dict.values.forEach { walk(start: $0, ignoreValue: ignoreValue, action: action) }
            }
        } else if let array = start as? [Any] {
            array.forEach { walk(start: $0, ignoreValue: ignoreValue, action: action) }
        } else {
            action(start)
        }
    }
}
