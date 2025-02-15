//
//  ItemView.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 15.02.2025.
//

import SwiftUI

struct ItemView: View {
    let size: CGFloat?
    let model: ItemModel

    var body: some View {
        Text("\(model.number)")
            .font(.title)
            .frame(width: size, height: size)
            .background(model.type == .rabbit ? .blue : (model.type == .wolfMale ? .red : .orange))
            .foregroundColor(.white)
    }
}
