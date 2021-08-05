//
//  Puzzle07.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

fileprivate enum Operand: CustomStringConvertible {
    case wire(name: String)
    case constant(value: UInt16)

    static func from(_ str: String) -> Operand {
        if let constant = UInt16(str) {
            return .constant(value: constant)
        } else {
            return .wire(name: str)
        }
    }

    func value(_ solved: [String: UInt16]) -> UInt16? {
        switch self {
        case .wire(let name): return solved[name]
        case .constant(let value): return value
        }
    }

    var description: String {
        switch self {
        case .wire(let name): return name
        case .constant(let value): return "\(value)"
        }
    }
}

fileprivate enum Op: CustomStringConvertible {
    case and(op1: Operand, op2: Operand)
    case or(op1: Operand, op2: Operand)
    case lshift(op1: Operand, op2: Operand)
    case rshift(op1: Operand, op2: Operand)
    case not(op: Operand)
    case equal(op: Operand)

    // str can be "br AND 3", "NOT 56", "br", "3", "aq LSHIFT pr" etc.
    static func from(_ str: String) -> Op {
        let split = str.components(separatedBy: " ")
        if split.count == 3 { // AND, OR, LSHIFT or RSHIFT
            let op1 = Operand.from(split[0])
            let op2 = Operand.from(split[2])
            let op = split[1]
            if op == "AND" { return .and(op1: op1, op2: op2) }
            if op == "OR" { return .or(op1: op1, op2: op2) }
            if op == "LSHIFT" { return .lshift(op1: op1, op2: op2) }
            if op == "RSHIFT" { return .rshift(op1: op1, op2: op2) }
        } else if split.count == 2 { // NOT
            return .not(op: Operand.from(split[1]))
        } else if split.count == 1 { // wire name or constant
            return .equal(op: Operand.from(split[0]))
        }
        fatalError("Invalid Operation -> \(str)")
    }

    func solve(_ solved: [String: UInt16]) -> UInt16? {
        var solution: UInt16?
        switch self {
        case .and(let op1, let op2):
            if let v1 = op1.value(solved), let v2 = op2.value(solved) {
                solution = v1 & v2
            }
        case .or(let op1, let op2):
            if let v1 = op1.value(solved), let v2 = op2.value(solved) {
                solution = v1 | v2
            }
        case .lshift(let op1, let op2):
            if let v1 = op1.value(solved), let v2 = op2.value(solved) {
                solution = v1 << v2
            }
        case .rshift(let op1, let op2):
            if let v1 = op1.value(solved), let v2 = op2.value(solved) {
                solution = v1 >> v2
            }
        case .not(let op):
            if let v = op.value(solved) {
                solution = ~v
            }
        case .equal(let op):
            if let v = op.value(solved) {
                solution = v
            }
        }
        return solution
    }

    var description: String {
        switch self {
        case .and(let op1, let op2): return "\(op1) AND \(op2)"
        case .or(let op1, let op2): return "\(op1) OR \(op2)"
        case .lshift(let op1, let op2): return "\(op1) LSHIFT \(op2)"
        case .rshift(let op1, let op2): return "\(op1) RSHIFT \(op2)"
        case .not(let op): return "NOT \(op)"
        case .equal(let op): return "\(op)"
        }
    }
}

struct Puzzle07: Puzzle {

    private let input: [String: Op]

    init() {
        var tmp = [String: Op]()
        InputFileReader.read("Input07").forEach { line in
            let split = line.components(separatedBy: " -> ")
            let key = split[1]
            let value = Op.from(split[0])
            tmp[key] = value
        }
        input = tmp
    }

    func part1() {
        let answer = solve(forWire: "a", input: input)
        print(answer ?? "no solution")
    }

    func part2() {
        var input = input
        input["b"] = .equal(op: .constant(value: 46065)) // 46065 is answer for p1
        let answer = solve(forWire: "a", input: input)
        print(answer ?? "no solution")
    }

    private func solve(forWire wire: String, input: [String: Op]) -> UInt16? {
        var solved = [String: UInt16]()
        var unsolved = [String: Op]()
        // Build the initial solved and unsolved dicts
        for (k,v) in input {
            if let solution = v.solve([:]) {
                solved[k] = solution
            } else {
                unsolved[k] = v
            }
        }
        assert(solved.count > 0, "No unsolved wires. Cannot proceed.")
        // Loop until there are no unsolved wires
        while !unsolved.isEmpty {
            var newUnsolved = [String: Op]()
            for (k, v) in unsolved {
                if let solution = v.solve(solved) {
                    solved[k] = solution
                } else {
                    newUnsolved[k] = v
                }
            }
            unsolved = newUnsolved
        }
        return solved[wire]
    }
}
