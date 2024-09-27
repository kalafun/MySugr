//
//  ContentViewModel.swift
//  MySugr
//
//  Created by Tomas Bobko on 27.09.24.
//

import Foundation

enum MeasurementUnit: String, Identifiable {
    var id: Self { self }

    case mgdl = "mg/dL"
    case mmoll = "mmol/L"

    static var allCases: [Self] = {
        [mgdl, mmoll]
    }()
}

extension ContentView {

    @MainActor
    class ViewModel: ObservableObject {
        @Published var average: Double?
        @Published var selectedMeasurementUnit: MeasurementUnit = .mgdl
        @Published var textInput = ""

        func save() {
            fatalError("not implemented yet")
        }
    }
}
