//
//  ItemView.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 15.02.2025.
//

import SwiftUI

struct ItemView: View {
    let size: CGFloat?
    let model: Animal

    var body: some View {
        if model.type != .empty {
            Text("")
                .font(.system(size: 13))
                .frame(width: size, height: size)
                .background(model.type == .rabbit ? .blue : (model.type == .wolfMale ? .red : .pink))
                .foregroundColor(.white)
        } else {
            Color.clear
                .frame(width: size, height: size)
        }
        
    }
}
