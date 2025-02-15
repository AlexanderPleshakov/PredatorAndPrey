//
//  FieldGenerator.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 15.02.2025.
//
import Foundation

final class FieldGenerator {
    func generateField(width: Int, height: Int, rabbits: Int, wolfMale: Int, wolfFemale: Int) throws -> [[ItemModel?]] {
        if width * height < rabbits + wolfMale + wolfFemale {
            throw GenerationError.smallField
        }
        var currentRabits = rabbits
        var currentwolfMale = wolfMale
        var currentwolfFemale = wolfFemale
        
        var resultArray: [[ItemModel?]] = Array(repeating: Array(repeating: nil, count: width), count: height)
        
        while currentRabits + currentwolfMale + currentwolfFemale != 0 {
            let rowIndex = Int.random(in: 0..<height)
            let modelIndex = Int.random(in: 0..<width)
            
            if resultArray[rowIndex][modelIndex] != nil {
                continue
            } else {
                let type = Int.random(in: 0..<3)
                if type == 0  && currentRabits > 0 {
                    resultArray[rowIndex][modelIndex] = ItemModel(number: rabbits, type: .rabbit)
                    currentRabits -= 1
                } else if type == 1 && currentwolfMale > 0 {
                    resultArray[rowIndex][modelIndex] = ItemModel(number: wolfMale, type: .wolfMale)
                    currentwolfMale -= 1
                } else if type == 2 && currentwolfFemale > 0 {
                    resultArray[rowIndex][modelIndex] = ItemModel(number: wolfFemale, type: .wolfFemale)
                    currentwolfFemale -= 1
                }
            }
        }
        
        return resultArray
    }
}
