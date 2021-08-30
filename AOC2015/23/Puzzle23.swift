//
//  Puzzle23.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

fileprivate enum Instruction: String {
    case hlf, tpl, inc, jmp, jie, jio
}

fileprivate struct Command {
    let instruction: Instruction
    let register: Character?
    let offset: Int?
}

struct Puzzle23: Puzzle {
    private let commands: [Command]

    init() {
        commands = InputFileReader.read("Input23").map { line in
            let split = line.components(separatedBy: " ")
            let instruction = Instruction(rawValue: split[0])!
            var register: Character? = nil
            var offset: Int? = nil
            switch instruction {
            case .hlf, .tpl, .inc:
                register = split[1].first
            case .jmp:
                offset = Int(split[1])!
            case .jie, .jio:
                register = split[1].first
                offset = Int(split[2])!
            }
            return Command(instruction: instruction, register: register, offset: offset)
        }
    }

    func part1() {
        var registers: [Character: Int] = ["a": 0, "b": 0]
        execute(commands: commands, registers: &registers)
        print(registers["b"] ?? "woops")
    }

    func part2() {
        var registers: [Character: Int] = ["a": 1, "b": 0]
        execute(commands: commands, registers: &registers)
        print(registers["b"] ?? "woops")
    }

    private func execute(commands: [Command], registers: inout [Character: Int]) {
        var pc = 0
        while pc < commands.count {
            let command = commands[pc]
            switch command.instruction {
            case .hlf:
                let register = command.register!
                registers[register, default: 0] /= 2
                pc += 1
            case .tpl:
                let register = command.register!
                registers[register, default: 0] *= 3
                pc += 1
            case .inc:
                let register = command.register!
                registers[register, default: 0] += 1
                pc += 1
            case .jmp:
                let offset = command.offset!
                pc += offset
            case .jie:
                let register = command.register!
                let offset = command.offset!
                if registers[register, default: 0] % 2 == 0 {
                    pc += offset
                } else {
                    pc += 1
                }
            case .jio:
                let register = command.register!
                let offset = command.offset!
                if registers[register, default: 0] == 1 {
                    pc += offset
                } else {
                    pc += 1
                }
            }
        }
    }
}
