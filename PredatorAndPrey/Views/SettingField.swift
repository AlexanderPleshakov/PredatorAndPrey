//
//  SettingField.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 15.02.2025.
//

import SwiftUI

struct SettingField: View {
    @Binding<String> var count: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(text)
                .font(.system(size: 12, weight: .light))
            TextField(LocalizedStringKey(text), text: $count)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
            .padding(.horizontal, 10)
    }
}
