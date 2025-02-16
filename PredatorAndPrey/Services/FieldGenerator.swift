//
//  FieldGenerator.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 15.02.2025.
//
import Foundation



final class FieldGenerator {
    func generateField(
        width: Int,
        height: Int,
        rabbits: Int,
        wolfMale: Int,
        wolfFemale: Int,
        wolfLifetime: Int
    ) throws -> [[Animal]] {
        if width * height < rabbits + wolfMale + wolfFemale {
            throw GenerationError.smallField
        }
        var currentRabits = rabbits
        var currentwolfMale = wolfMale
        var currentwolfFemale = wolfFemale
        
        var resultArray: [[Animal]] = Array(
            repeating: Array(
                repeating: Animal(
                    population: 0,
                    type: .empty,
                    hp: Double(wolfLifetime)
                ),
                count: width
            ),
            count: height
        )
        
        while currentRabits + currentwolfMale + currentwolfFemale != 0 {
            let rowIndex = Int.random(in: 0..<height)
            let modelIndex = Int.random(in: 0..<width)
            
            if resultArray[rowIndex][modelIndex].type != .empty {
                continue
            } else {
                let type = Int.random(in: 0..<3)
                if type == 0  && currentRabits > 0 {
                    resultArray[rowIndex][modelIndex] = Animal(
                        population: rabbits,
                        type: .rabbit,
                        hp: Double(wolfLifetime))
                    currentRabits -= 1
                } else if type == 1 && currentwolfMale > 0 {
                    resultArray[rowIndex][modelIndex] = Animal(
                        population: wolfMale,
                        type: .wolfMale,
                        hp: Double(wolfLifetime)
                    )
                    currentwolfMale -= 1
                } else if type == 2 && currentwolfFemale > 0 {
                    resultArray[rowIndex][modelIndex] = Animal(
                        population: wolfFemale,
                        type: .wolfFemale,
                        hp: Double(wolfLifetime)
                    )
                    currentwolfFemale -= 1
                }
            }
        }
        
        return resultArray
    }
}
