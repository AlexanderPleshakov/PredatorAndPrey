//
//  ContentView.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 15.02.2025.
//

import SwiftUI

enum GenerationError: Error {
    case smallField
}

struct ContentView: View {
    @State var rabbitCount: String = "50"
    @State var wolfsMaleCount: String = "15"
    @State var wolfsFemaleCount: String = "15"
    @State var wolfLifeTime: String = "50"
    @State var fieldWidth: String = "30"
    @State var fieldHeight: String = "15"
    
    @State var items: [ItemModel] = []
    @State var columns: [GridItem] = []
    @State var field: [[ItemModel?]] = []
    
    @State var error: Error? = nil
    
    var body: some View {
        GeometryReader { geometry in
            let windowWidth = geometry.size.width
            let menuWindowWidth = (windowWidth * 0.25 < 200 ? 200 : (windowWidth * 0.25 > 300 ? 300 : windowWidth * 0.25))
            let fieldWindowWidth: CGFloat = (menuWindowWidth < 200 ? windowWidth - 200 : (windowWidth * 0.25 > 300 ? windowWidth - 300 : windowWidth * 0.75))
            
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .center, spacing: 10) {
                    Text("Настройки симуляции")
                        .padding(.top)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.horizontal, 10)
                    
                    SettingField(
                        count: $rabbitCount,
                        text: "Количество кроликов"
                    )
                    
                    SettingField(
                        count: $wolfsMaleCount,
                        text: "Количество волков"
                    )
                    
                    SettingField(
                        count: $wolfsFemaleCount,
                        text: "Количество волчиц"
                    )
                    
                    SettingField(
                        count: $wolfLifeTime,
                        text: "Время жизни волка"
                    )
                    
                    SettingField(
                        count: $fieldWidth,
                        text: "Ширина поля"
                    )
                    
                    SettingField(
                        count: $fieldHeight,
                        text: "Высота поля"
                    )
                    
                    Button {
                        columns = Array(repeating: GridItem(.adaptive(minimum: 30)), count: Int(fieldWidth) ?? 0)
                        do {
                            self.field = try FieldGenerator().generateField(
                                width: Int(fieldWidth) ?? 0,
                                height: Int(fieldHeight) ?? 0,
                                rabbits: Int(rabbitCount) ?? 0,
                                wolfMale: Int(wolfsMaleCount) ?? 0,
                                wolfFemale: Int(wolfsFemaleCount) ?? 0
                            )
                            
                            print(field)
                        } catch {
                            self.error = error
                        }
                    } label: {
                        Text("Сгенерировать")
                            .frame(maxWidth: .infinity)
                    }
                    .keyboardShortcut(.defaultAction)
                    .controlSize(.large) //
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)

                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            SystemButton(title: "Старт", systemImage: "play.fill")
                            SystemButton(title: "Стоп", systemImage: "stop.fill")
                        }
                        SystemButton(title: "Шаг", systemImage: "arrow.right")
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 10)
                    
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)

                }
                .frame(width: menuWindowWidth)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(items, id: \.self) { item in
                            Text("\(item.number)")
                                .font(.title)
                                .frame(width: 30, height: 30)
                                .background(Color.red.opacity(0.7))
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
                .frame(width: fieldWindowWidth)
                .background(.white.opacity(0.2))
            }
        }
        .frame(minWidth: 700, idealWidth: 1200, minHeight: 500, idealHeight: 800)
    }
}

#Preview {
    ContentView()
}
