//
//  Puzzle20.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

struct Puzzle20: Puzzle {
    private let input = 33100000

    func part1() {
        let target = input / 10
        for i in (1...) {
            if sumOfFactors(of: i) >= target {
                print(i)
                break
            }
        }
    }

    func part2() {
        let target = input / 11
        var usedCount = [Int: Int]()
        for i in (1...) {
            if sumOfFactors2(of: i, usedCount: &usedCount) >= target {
                print(i)
                break
            }
        }
    }

    private func sumOfFactors(of n: Int) -> Int {
        let sqrt = Int(Double(n).squareRoot())
        var sum = 0
        for i in 1...sqrt {
            if n % i == 0 {
                let div = n/i
                sum += i
                if div != i {
                    sum += div
                }
            }
        }
        return sum
    }

    private func sumOfFactors2(of n: Int, usedCount: inout [Int: Int]) -> Int {
        let sqrt = Int(Double(n).squareRoot())
        var sum = 0
        for i in 1...sqrt {
            if n % i == 0 {
                let div = n/i
                let iCount = usedCount[i, default: 0]
                if iCount < 50 {
                    sum += i
                    usedCount[i] = iCount + 1
                }
                if div != i {
                    let divCount = usedCount[div, default: 0]
                    if divCount < 50 {
                        sum += div
                        usedCount[div] = divCount + 1
                    }
                }
            }
        }
        return sum
    }
}
