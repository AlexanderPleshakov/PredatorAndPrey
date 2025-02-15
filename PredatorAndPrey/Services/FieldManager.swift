//
//  FieldUpdater.swift
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
        parentPosition: (Int, Int)
    ) -> (Animal, (Int, Int), Int)?
}

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
                
                switch model.type {
                case .rabbit:
                    if let (newAnimal, newAnimalPosition, population) = reproductor.reproduce(
                        field: newField,
                        type: .rabbit,
                        population: rabbitCount,
                        parentPosition: currentPosition
                    ) {
                        newField.addAnimal(animal: newAnimal, position: newAnimalPosition)
                        rabbitCount = population
                    }
                    
                    if let newRabbitPosition = fieldMover.getRandomMovePosition(
                        on: newField,
                        currentPosition: (modelsIndex, elementIndex)
                    ) {
                        newField.swapPosition(
                            old: currentPosition,
                            new: newRabbitPosition
                        )
                    }
                case .wolfFemale:
                    if let newWolfPosititon = fieldMover.getRandomMovePosition(
                        on: newField,
                        currentPosition: (modelsIndex, elementIndex)
                    ) {
                        newField.swapPosition(
                            old: currentPosition,
                            new: newWolfPosititon
                        )
                    }
                case .wolfMale:
                    if let newWolfPosititon = fieldMover.getRandomMovePosition(
                        on: newField,
                        currentPosition: (modelsIndex, elementIndex)
                    ) {
                        newField.swapPosition(
                            old: currentPosition,
                            new: newWolfPosititon
                        )
                    }
                case .empty:
                    break
                }
            }
        }
        
        self.field = newField
        return newField
    }
}

final class AnimalReproductorImpl: AnimalReproductor {
    func reproduce(
        field: Array<[Animal]>,
        type: AnimalType,
        population: Int,
        parentPosition: (Int, Int)
    ) -> (Animal, (Int, Int), Int)? {
        var newAnimal: Animal?
        var newAnimalPosition: (Int, Int)?
        
        let fieldMover = FieldMoverImpl()
        
        switch type {
        case .rabbit:
            if Int.random(in: 0..<10) == 0 {
                if let position = fieldMover.getRandomMovePosition(
                    on: field,
                    currentPosition: parentPosition
                ) {
                    newAnimalPosition = position
                    newAnimal = Animal(population: population + 1, type: .rabbit)
                }
            }
        case .wolfMale:
            break
        case .wolfFemale:
            break
        case .empty:
            break
        }
        
        if let newAnimal, let newAnimalPosition {
            return (newAnimal, newAnimalPosition, population + 1)
        } else {
            return nil
        }
    }
}

extension Array where Element == [Animal] {
    mutating func swapPosition(old: (Int, Int), new: (Int, Int)) {
        let element = self[old.0][old.1]
        self[old.0][old.1] = Animal(population: 0, type: .empty)
        self[new.0][new.1] = element
    }
    
    mutating func addAnimal(animal: Animal, position: (Int, Int)) {
        self[position.0][position.1] = animal
    }
    
    mutating func updatePopulation(for animalType: AnimalType, value: Int) {
        guard let first = self.first, !self.isEmpty, !first.isEmpty else {
            return
        }
        
        for i in 0..<self.count - 1 {
            for j in 0..<self[0].count {
                if self[i][j].type == animalType {
                    self[i][j] = Animal(population: value, type: .rabbit)
                }
            }
        }
    }
}
