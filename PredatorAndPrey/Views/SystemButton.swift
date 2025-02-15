//
//  SystemButton.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 15.02.2025.
//

import SwiftUI

struct SystemButton: View {
    var title: String
    var systemImage: String
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Label(title, systemImage: systemImage)
                .frame(maxWidth: .infinity)
        }

        .controlSize(.regular) // Автоматический размер
        .buttonStyle(.bordered) // Системный стиль
    }
}
