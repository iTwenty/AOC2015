//
//  Puzzle15.swift
//  AOC2015
//
//  Created by Jaydeep Joshi on 31/07/21.
//

struct Puzzle15: Puzzle {

    private var ingredients: [String: [Int]] // eg: [Sugar: [3, 5, 0, -2, 8]]

    init() {
        ingredients = [:]
        InputFileReader.read("Input15").forEach { line in
            let stripped = line.replacingOccurrences(of: "[:,]", with: "", options: [.regularExpression])
            let split = stripped.split(separator: " ")
            let ingredientName = String(split[0])
            let propertyValues = [Int(split[2])!, Int(split[4])!, Int(split[6])!, Int(split[8])!, Int(split[10])!]
            ingredients[ingredientName] = propertyValues
        }
    }

    func part1() {
        var max = Int.min
        makeCookie(amounts: [:], remainingAmount: 100, remainingIngredients: Array(ingredients.keys), currentMax: &max)
        print(max)
    }

    func part2() {
        var max = Int.min
        makeCookie(amounts: [:], remainingAmount: 100, remainingIngredients: Array(ingredients.keys), targetCalories: 500, currentMax: &max)
        print(max)
    }

    private func makeCookie(amounts: [String: Int], remainingAmount: Int, remainingIngredients: [String], targetCalories: Int? = nil, currentMax: inout Int) {
        if remainingIngredients.count == 1 {
            var newAmounts = amounts
            newAmounts[remainingIngredients[0]] = remainingAmount
            let score = score(amounts: newAmounts, ingredients: ingredients)
            if let targetCal = targetCalories {
                if score.calories == targetCal {
                    currentMax = max(currentMax, score.score)
                }
            } else {
                currentMax = max(currentMax, score.score)
            }
        } else {
            for i in 0...remainingAmount {
                let selected = remainingIngredients[0]
                let newRemaining = Array(remainingIngredients.dropFirst())
                var newAmounts = amounts
                newAmounts[selected] = i
                makeCookie(amounts: newAmounts, remainingAmount: remainingAmount - i, remainingIngredients: newRemaining, targetCalories: targetCalories, currentMax: &currentMax)
            }
        }
    }

    private func score(amounts: [String: Int], ingredients: [String: [Int]]) -> (score: Int, calories: Int) {
        var totalScore = 1
        var calories = 0
        for i in 0..<5 {
            var propertyScore = 0
            for ingredient in ingredients {
                let amount = amounts[ingredient.key]!
                // index 4 means calories property.
                if i == 4 {
                    calories += (ingredient.value[i] * amount)
                } else {
                    propertyScore += (ingredient.value[i] * amount)
                }
            }
            if i != 4 {
                propertyScore = max(0, propertyScore)
                totalScore *= propertyScore
            }

        }
        return (totalScore, calories)
    }
}
