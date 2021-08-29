//
//  Puzzle22.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//
//  Trying 2 spaces indent in this file.

import Collections

fileprivate enum GameResult: String, CustomStringConvertible {
  case fighting, won, lost
  var description: String { self.rawValue }
}

fileprivate enum Spell: String, CustomStringConvertible, CaseIterable {
  case magicMissile, drain, shield, poison, recharge

  var description: String { self.rawValue }

  var manaCost: Int {
    switch self {
    case .magicMissile: return 53
    case .drain: return 73
    case .shield: return 113
    case .poison: return 173
    case .recharge: return 229
    }
  }

  func cast(_ state: inout GameState) {
    state.playerMana -= self.manaCost
    if let effect = effect {
      state.effects[effect] = effect.effectiveTurns
    } else if case .magicMissile = self {
      state.bossHp -= 4
    } else { // drain
      state.bossHp -= 2
      state.playerHp += 2
    }
  }

  var effect: Effect? {
    switch self {
    case .shield: return Effect.shield
    case .poison: return Effect.poison
    case .recharge: return Effect.recharge
    default: return nil
    }
  }
}

fileprivate enum Effect: String, CustomStringConvertible {
  case shield, poison, recharge

  var description: String { self.rawValue }

  var effectiveTurns: Int {
    switch self {
    case .shield: return 6
    case .poison: return 6
    case .recharge: return 5
    }
  }
}

fileprivate struct GameState {
  static let start = GameState(bossHp: 71, bossDmg: 10, playerHp: 50, playerShield: 0,
                               playerMana: 500, effects: [:], result: .fighting)
  var bossHp, bossDmg, playerHp, playerShield, playerMana: Int
  var effects: [Effect: Int] // Effect : Turns remaining
  var result: GameResult
}

struct Puzzle22: Puzzle {

  func part1() {
    var fightingStates =  Deque([(GameState.start, 0)])
    var minCostWonState = (GameState.start, Int.max)

    while !fightingStates.isEmpty {
      let tmp = fightingStates.removeFirst()
      let state = tmp.0
      let spent = tmp.1
      let spells = nonActiveSpells(state)
      for spell in spells {
        let newState = playTurn(state, spell: spell, hardMode: false)
        switch newState.result {
        case .fighting:
          fightingStates.append((newState, spent + (spell.manaCost)))
        case .won:
          let cost = spent + (spell.manaCost)
          if cost < minCostWonState.1 {
            minCostWonState = (newState, cost)
          }
        case .lost: break
        }
      }
    }
    print(minCostWonState)
  }

  func part2() {
    var fightingStates =  Deque([(GameState.start, 0)])
    var minCostWonState = (GameState.start, Int.max) // (State, total manaCost to reach the state)

    while !fightingStates.isEmpty {
      let tmp = fightingStates.removeFirst()
      let state = tmp.0
      let spent = tmp.1
      let spells = nonActiveSpells(state)
      for spell in spells {
        let newState = playTurn(state, spell: spell, hardMode: true)
        switch newState.result {
        case .fighting:
          fightingStates.append((newState, spent + (spell.manaCost)))
        case .won:
          let cost = spent + (spell.manaCost)
          if cost < minCostWonState.1 {
            minCostWonState = (newState, cost)
          }
        case .lost: break
        }
      }
    }
    print(minCostWonState)
  }

  private func playTurn(_ current: GameState, spell: Spell, hardMode: Bool) -> GameState {
    guard case .fighting = current.result else {
      return current
    }
    var next = current
    // In hard mode player loses 1 HP at beginning of every player turn
    if hardMode {
      next.playerHp -= 1
      if next.playerHp <= 0 {
        next.result = .lost
        return next
      }
    }
    // Player goes first
    applyPoison(&next)
    // Bose can lose after poison is applied
    if next.bossHp <= 0 {
      next.result = .won
      return next
    }
    applyShield(&next)
    applyRecharge(&next)
    // Not enough mana to cast spell means player loss
    if next.playerMana < spell.manaCost {
      next.result = .lost
      return next
    }
    spell.cast(&next)
    // Only boss can lose on player turn
    if next.bossHp <= 0 {
      next.result = .won
      return next
    }

    // Boss goes after player
    applyPoison(&next)
    // Bose can lose after poison is applied
    if next.bossHp <= 0 {
      next.result = .won
      return next
    }
    applyShield(&next)
    applyRecharge(&next)
    let bossDmg = max(1, (next.bossDmg - next.playerShield))
    next.playerHp -= bossDmg
    // Only player can lose on boss turn
    if next.playerHp <= 0 {
      next.result = .lost
      return next
    }
    // Neither player nor boss lost. The fighting continues...
    return next
  }

  private func applyPoison(_ state: inout GameState) {
    if let remainingTurns = state.effects[.poison] {
      state.bossHp -= 3
      state.effects[.poison] = remainingTurns == 1 ? nil : remainingTurns - 1
    }
  }

  private func applyShield(_ state: inout GameState) {
    if let remainingTurns = state.effects[.shield] {
      state.playerShield = 7
      state.effects[.shield] = remainingTurns == 1 ? nil : remainingTurns - 1
    } else {
      state.playerShield = 0
    }
  }

  private func applyRecharge(_ state: inout GameState) {
    if let remainingTurns = state.effects[.recharge] {
      state.playerMana += 101
      state.effects[.recharge] = remainingTurns == 1 ? nil : remainingTurns - 1
    }
  }

  private func nonActiveSpells(_ state: GameState) -> [Spell] {
    return Spell.allCases.filter { spell in
      // If spell has no associated effect, it cannot be active
      guard let spellEffect = spell.effect else {
        return true
      }
      // If the associated effect is not in active effects, it is non active
      guard let remainingTurns = state.effects[spellEffect] else {
        return true
      }
      // If there's one turn of effect remaining, it will be used at beginning
      // and spell can be cast again in same turn
      if remainingTurns == 1 {
        return true
      }
      return false
    }
  }
}
