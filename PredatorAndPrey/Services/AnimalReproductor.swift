//
//  AnimalReproductor.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 16.02.2025.
//

import Foundation

protocol AnimalReproductor {
    func reproduce(
        field: Array<[Animal]>,
        type: AnimalType,
        population: Int,
        parentPosition: (Int, Int),
        maxHP: Double
    ) -> (Animal, (Int, Int), Int?)?
}

final class AnimalReproductorImpl: AnimalReproductor {
    func reproduce(
        field: Array<[Animal]>,
        type: AnimalType,
        population: Int,
        parentPosition: (Int, Int),
        maxHP: Double
    ) -> (Animal, (Int, Int), Int?)? {
        var newAnimal: Animal?
        var newAnimalPosition: (Int, Int)?
        
        let fieldMover = FieldMoverImpl()
        
        switch type {
        case .rabbit:
            if Int.random(in: 0..<10) == 0 {
                if let position = fieldMover.getRandomPosition(
                    on: field,
                    currentPosition: parentPosition
                ) {
                    newAnimalPosition = position
                    newAnimal = Animal(population: population + 1, type: .rabbit, hp: -1)
                }
            }
        case .wolfMale:
            if let femalePosition = fieldMover.getRandomPosition(
                on: field,
                currentPosition: parentPosition,
                findType: .wolfFemale
            ) {
                if let childPosition = fieldMover.getRandomPosition(
                    on: field,
                    currentPosition: parentPosition,
                    findType: .empty
                ) {
                    if field[parentPosition.0][parentPosition.1].hp > maxHP * 0.75 && field[femalePosition.0][femalePosition.1].hp > maxHP * 0.75
                    {
                        newAnimalPosition = childPosition
                        newAnimal = Animal(
                            population: population + 1,
                            type: Bool.random() ? .wolfMale : .wolfFemale,
                            hp: maxHP
                        )
                    }
                }
            }
        case .wolfFemale:
            if let malePosition = fieldMover.getRandomPosition(
                on: field,
                currentPosition: parentPosition,
                findType: .wolfMale
            ) {
                if let childPosition = fieldMover.getRandomPosition(
                    on: field,
                    currentPosition: parentPosition,
                    findType: .empty
                ) {
                    if field[parentPosition.0][parentPosition.1].hp > maxHP * 0.75 && field[malePosition.0][malePosition.1].hp > maxHP * 0.75
                    {
                        newAnimalPosition = childPosition
                        newAnimal = Animal(
                            population: population + 1,
                            type: Bool.random() ? .wolfMale : .wolfFemale,
                            hp: maxHP
                        )
                    }
                }
            }
        case .empty:
            break
        }
        
        if let newAnimal, let newAnimalPosition {
            if type == .rabbit {
                return (newAnimal, newAnimalPosition, population + 1)
            } else {
                return (newAnimal, newAnimalPosition, nil)
            }
        } else {
            return nil
        }
    }
}
