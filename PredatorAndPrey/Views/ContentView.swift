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
    
    @State var items: [Animal] = []
    @State var columns: [GridItem] = []
    
    @State var error: Error? = nil
    
    @State var windowWidth: CGFloat = 0
    @State var menuWindowWidth: CGFloat = 0
    @State var fieldWindowWidth: CGFloat = 0
    @State var fieldWindowHeight: CGFloat = 0
    @State var cellSize: CGFloat = 0
    
    @State var simulationRunning = false
    @State private var timer: Timer?
    
    @ObservedObject var fieldManager: FieldManager
     
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
                        columns = Array(repeating: GridItem(.adaptive(minimum: 500 / CGFloat(Int(fieldWidth) ?? 1)), spacing: 0), count: Int(fieldWidth) ?? 0)
                        do {
                            let field = try FieldGenerator().generateField(
                                width: Int(fieldWidth) ?? 0,
                                height: Int(fieldHeight) ?? 0,
                                rabbits: Int(rabbitCount) ?? 0,
                                wolfMale: Int(wolfsMaleCount) ?? 0,
                                wolfFemale: Int(wolfsFemaleCount) ?? 0,
                                wolfLifetime: Int(wolfLifeTime) ?? 0
                            )
                            updateItems(with: field)
                            
                            fieldManager.setInitialState(
                                rabbitCount: Int(rabbitCount) ?? 0,
                                wolfsMaleCount: Int(wolfsMaleCount) ?? 0,
                                wolfsFemaleCount: Int(wolfsFemaleCount) ?? 0,
                                wolfLifeTime: Int(wolfLifeTime) ?? 0,
                                field: field
                            )
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
                            SystemButton(title: "Старт", systemImage: "play.fill") {
                                simulationRunning = true
                                timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                                    if simulationRunning {
                                        let field = fieldManager.nextStep()
                                        updateItems(with: field)
                                    } else {
                                        timer?.invalidate()
                                    }
                                }
                            }
                            SystemButton(title: "Стоп", systemImage: "stop.fill") {
                                simulationRunning = false
                                timer?.invalidate()
                            }
                        }
                        SystemButton(title: "Шаг", systemImage: "arrow.right") {
                            let field = fieldManager.nextStep()
                            updateItems(with: field)
                        }
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)

                }
                .frame(width: menuWindowWidth)
                
                ScrollView([.horizontal, .vertical]) {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
                        ForEach(items) { item in
                            ItemView(size: 30, model: item)
                        }
                    }
                    .frame(alignment: .topLeading)
                    .background(.white.opacity(0.1))
                }
                .background(.white.opacity(0.2))
            }
        }
        .frame(minWidth: 700, idealWidth: 1200, minHeight: 500, idealHeight: 800)
    }
    
    private func updateItems(with field: Array<[Animal]>) {
        var resultItems: [Animal] = []
        for models in field {
            resultItems += models
        }
        self.items = resultItems
    }
}

#Preview {
    ContentView(fieldManager: FieldManager())
}
