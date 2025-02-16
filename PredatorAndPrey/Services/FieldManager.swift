//
//  FieldUpdater.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 16.02.2025.
//

import Foundation



protocol FieldUpdater: ObservableObject {
    func nextStep() -> Array<[Animal]>
}

final class FieldManager: FieldUpdater {
    private var rabbitCount: Int
    private var wolfsMaleCount: Int
    private var wolfsFemaleCount: Int
    private var wolfLifeTime: Int
    
    @Published var field: Array<[Animal]>
    
    private let fieldMover: FieldMover = FieldMoverImpl()
    private let reproductor: AnimalReproductor = AnimalReproductorImpl()
    
    init() {
        self.rabbitCount = 0
        self.wolfsMaleCount = 0
        self.wolfsFemaleCount = 0
        self.wolfLifeTime = 0
        
        self.field = []
    }
    
    func setInitialState(
        rabbitCount: Int,
        wolfsMaleCount: Int,
        wolfsFemaleCount: Int,
        wolfLifeTime: Int,
        field: Array<[Animal]>
    ) {
        self.rabbitCount = rabbitCount
        self.wolfsMaleCount = wolfsMaleCount
        self.wolfsFemaleCount = wolfsFemaleCount
        self.wolfLifeTime = wolfLifeTime
        
        self.field = field
    }
    
    func nextStep() -> Array<[Animal]> {
        var newField = field
        for (modelsIndex, models) in field.enumerated() {
            for (elementIndex, model) in models.enumerated() {
                let currentPosition = (modelsIndex, elementIndex)
                let animal = newField[modelsIndex][elementIndex]
                
                switch model.type {
                case .rabbit:
                    if let (newAnimal, newAnimalPosition, population) = reproductor.reproduce(
                        field: newField,
                        type: .rabbit,
                        population: rabbitCount,
                        parentPosition: currentPosition,
                        maxHP: -1
                    ) {
                        newField.addAnimal(animal: newAnimal, position: newAnimalPosition)
                        rabbitCount = population ?? 0
                    }
                    
                    if let newRabbitPosition = fieldMover.getRandomPosition(
                        on: newField,
                        currentPosition: (modelsIndex, elementIndex),
                        findType: .empty
                    ) {
                        newField.swapPositionAndChangeHP(
                            old: currentPosition,
                            new: newRabbitPosition
                        )
                    }
                case .wolfFemale:
                    if let (child, childPosition, _) = reproductor.reproduce(
                        field: field,
                        type: .wolfFemale,
                        population: wolfsFemaleCount,
                        parentPosition: currentPosition,
                        maxHP: Double(wolfLifeTime)
                    ) {
                        if child.type == .wolfMale {
                            wolfsMaleCount += 1
                        } else if child.type == .wolfFemale {
                            wolfsFemaleCount += 1
                        }
                        newField.addAnimal(animal: child, position: childPosition)
                    }
                    moveWolf(animal, field: &newField, currentPosition: currentPosition)
                case .wolfMale:
                    if let (child, childPosition, _) = reproductor.reproduce(
                        field: field,
                        type: .wolfMale,
                        population: wolfsFemaleCount,
                        parentPosition: currentPosition,
                        maxHP: Double(wolfLifeTime)
                    ) {
                        if child.type == .wolfMale {
                            wolfsMaleCount += 1
                        } else if child.type == .wolfFemale {
                            wolfsFemaleCount += 1
                        }
                        newField.addAnimal(animal: child, position: childPosition)
                    }
                    moveWolf(animal, field: &newField, currentPosition: currentPosition)
                case .empty:
                    break
                }
            }
        }
        
        self.field = newField
        return newField
    }
    
    private func moveWolf(
        _ wolf: Animal,
        field: inout Array<[Animal]>,
        currentPosition: (Int, Int)
    ) {
        if wolf.hp < Double(wolfLifeTime) / 2 {
            if let rabbitPosition = fieldMover.getRandomPosition(
                on: field,
                currentPosition: currentPosition,
                findType: .rabbit
            ) {
                field.eatRabbit(
                    wolfType: wolf.type,
                    maxHP: Double(wolfLifeTime),
                    wolfPosition: currentPosition,
                    rabbitPosition: rabbitPosition
                )
                rabbitCount -= 1
            } else {
                field.changeHPAndDeleteIfNeeded(position: currentPosition)
            }
        } else {
            if let newWolfPosititon = fieldMover.getRandomPosition(
                on: field,
                currentPosition: currentPosition,
                findType: .empty
            ) {
                let movedWolf = field.swapPositionAndChangeHP(
                    old: currentPosition,
                    new: newWolfPosititon
                )
                if movedWolf == nil {
                    if wolf.type == .wolfFemale {
                        wolfsFemaleCount -= 1
                    } else {
                        wolfsMaleCount -= 1
                    }
                }
            } else {
                field.changeHPAndDeleteIfNeeded(position: currentPosition)
            }
        }
    }
}

extension Array where Element == [Animal] {
    @discardableResult
    mutating func swapPositionAndChangeHP(old: (Int, Int), new: (Int, Int)) -> Animal? {
        var element: Animal = self[old.0][old.1]
        self[old.0][old.1] = Animal(population: 0, type: .empty, hp: -1)
        if element.type == .rabbit {
            self[new.0][new.1] = element
        } else {
            element = Animal(population: element.population, type: element.type, hp: element.hp - 1)
            if element.hp <= 0 {
                self[new.0][new.1] = Animal(population: 0, type: .empty, hp: -1)
                return nil
            } else {
                self[new.0][new.1] = element
            }
        }
        
        return element
    }
    
    @discardableResult
    mutating func changeHPAndDeleteIfNeeded(position: (Int, Int)) -> Animal? {
        var element = self[position.0][position.1]
        element = Animal(population: element.population, type: element.type, hp: element.hp - 1)
        if element.hp <= 0 {
            self[position.0][position.1] = Animal(population: 0, type: .empty, hp: -1)
            return nil
        } else {
            self[position.0][position.1] = element
        }
        
        return element
    }
    
    @discardableResult
    mutating func eatRabbit(
        wolfType: AnimalType,
        maxHP: Double,
        wolfPosition: (Int, Int),
        rabbitPosition: (Int, Int)
    ) -> Animal {
        let element = self[wolfPosition.0][wolfPosition.1]
        self[wolfPosition.0][wolfPosition.1] = Animal(population: 0, type: .empty, hp: -1)
        let wolf = Animal(
            population: element.population,
            type: wolfType,
            hp: maxHP
        )
        self[rabbitPosition.0][rabbitPosition.1] = wolf
        
        return wolf
    }
    
    mutating func addAnimal(animal: Animal, position: (Int, Int)) {
        self[position.0][position.1] = animal
    }
    
    mutating func updatePopulation(for animalType: AnimalType, value: Int, hp: Double? = nil) {
        guard let first = self.first, !self.isEmpty, !first.isEmpty else {
            return
        }
        
        for i in 0..<self.count - 1 {
            for j in 0..<self[0].count {
                if self[i][j].type == animalType {
                    self[i][j] = Animal(population: value, type: animalType, hp: hp ?? -1)
                }
            }
        }
    }
}
