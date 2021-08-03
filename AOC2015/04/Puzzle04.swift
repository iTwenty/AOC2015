//
//  Puzzle04.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

import CryptoKit

struct Puzzle04: Puzzle {

    private let input = "ckczppom"

    func part1() {
        var salt = 1
        var md5: String?
        while true {
            md5 = "\(input)\(salt)".md5Hex()
            if (md5?.starts(with: "00000") ?? false) {
                break
            }
            salt += 1
        }
        print(salt)
    }

    func part2() {
        var salt = 1
        var md5: String?
        while true {
            md5 = "\(input)\(salt)".md5Hex()
            if (md5?.starts(with: "000000") ?? false) {
                break
            }
            salt += 1
        }
        print(salt)
    }
}
