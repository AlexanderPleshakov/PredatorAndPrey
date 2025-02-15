//
//  Animal.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 15.02.2025.
//

import Foundation

struct Animal: Hashable, Identifiable {
    let id: UUID = UUID()
    let population: Int
    let type: AnimalType
}
