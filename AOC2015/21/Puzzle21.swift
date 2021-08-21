//
//  Puzzle21.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

fileprivate struct Dude {
    let hp, dmg, armor: Int
}

fileprivate struct Gear: Equatable, CustomStringConvertible {
    let name: String
    let cost, dmg, armor: Int

    var description: String {
        "\(name) Damage \(dmg) Armor \(armor) Cost \(cost)"
    }
}

struct Puzzle21: Puzzle {
    private let weapons = [Gear(name: "Dagger", cost: 8, dmg: 4, armor: 0),
                           Gear(name: "Shortsword", cost: 10, dmg: 5, armor: 0),
                           Gear(name: "Warhammer", cost: 25, dmg: 6, armor: 0),
                           Gear(name: "Longsword", cost: 40, dmg: 7, armor: 0),
                           Gear(name: "Greataxe", cost: 74, dmg: 8, armor: 0)]
    private let armors = [Gear(name: "Naked", cost: 0, dmg: 0, armor: 0),
                          Gear(name: "Leather", cost: 13, dmg: 0, armor: 1),
                          Gear(name: "Chainmail", cost: 31, dmg: 0, armor: 2),
                          Gear(name: "Splintmail", cost: 53, dmg: 0, armor: 3),
                          Gear(name: "Blandedmail", cost: 75, dmg: 0, armor: 4),
                          Gear(name: "Platemail", cost: 102, dmg: 0, armor: 5)]
    private let rings = [Gear(name: "None1", cost: 0, dmg: 0, armor: 0),
                         Gear(name: "None2", cost: 0, dmg: 0, armor: 0),
                         Gear(name: "Damage1", cost: 25, dmg: 1, armor: 0),
                         Gear(name: "Damage2", cost: 50, dmg: 2, armor: 0),
                         Gear(name: "Damage3", cost: 100, dmg: 3, armor: 0),
                         Gear(name: "Defense1", cost: 20, dmg: 0, armor: 1),
                         Gear(name: "Defense2", cost: 40, dmg: 0, armor: 2),
                         Gear(name: "Defense3", cost: 80, dmg: 0, armor: 3)]

    private let boss = Dude(hp: 100, dmg: 8, armor: 2)

    func part1() {
        var minCostWinningGear = (gear: [Gear](), cost: Int.max)
        var maxCostLosingGear = (gear: [Gear](), cost: Int.min)
        for weapon in weapons {
            for armor in armors {
                for ring1 in rings {
                    for ring2 in rings where ring1 != ring2 {
                        let gear = [weapon, armor, ring1, ring2]
                        let cost = gear.map(\.cost).reduce(0, +)
                        let dmg = gear.map(\.dmg).reduce(0, +)
                        let armor = gear.map(\.armor).reduce(0, +)
                        let player = Dude(hp: 100, dmg: dmg, armor: armor)
                        if playerWins(player: player, boss: boss) {
                            if cost < minCostWinningGear.cost {
                                minCostWinningGear = (gear, cost)
                            }
                        } else {
                            if cost > maxCostLosingGear.cost {
                                maxCostLosingGear = (gear, cost)
                            }
                        }
                    }
                }
            }
        }
        print("Cheapest winning gear is : ")
        minCostWinningGear.gear.forEach { print($0) }
        print("Cost : \(minCostWinningGear.cost)")
        print("\n")
        print("Costliest losing gear is : ")
        maxCostLosingGear.gear.forEach { print($0) }
        print("Cost : \(maxCostLosingGear.cost)")
    }

    func part2() { /* Done in part1 */ }

    private func playerWins(player: Dude, boss: Dude) -> Bool {
        let playerDmg = max(1, player.dmg - boss.armor)
        let bossDmg = max(1, boss.dmg - player.armor)
        let playerTurns = (Double(boss.hp) / Double(playerDmg)).rounded(.up)
        let bossTurns = (Double(player.hp) / Double(bossDmg)).rounded(.up)
        return playerTurns <= bossTurns
    }
}
