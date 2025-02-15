//
//  ItemModel.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 15.02.2025.
//

import Foundation

struct ItemModel: Hashable, Identifiable {
    let id: UUID = UUID()
    let number: Int
    let type: ItemViewType
}
