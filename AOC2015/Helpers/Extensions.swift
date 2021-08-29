//
//  Extensions.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 03/08/21.
//

import Foundation
import CryptoKit

enum Either<L, R> {
  case left(L), right(R)
}

extension String {
    func md5Hex() -> String {
        return Insecure.MD5.hash(data: self.data(using: .utf8)!).map {
            String(format: "%02hhx", $0)
        }.joined()
    }

    func pad(with char: Character, toSize size: Int) -> String {
        let paddingSize = size - self.count
        if paddingSize <= 0 {
            return self
        }
        var padded = self
        for _ in (0..<paddingSize) {
            padded = "\(char)\(padded)"
        }
        return padded
    }
}
