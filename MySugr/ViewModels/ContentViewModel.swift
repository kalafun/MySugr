//
//  ContentViewModel.swift
//  MySugr
//
//  Created by Tomas Bobko on 27.09.24.
//

import Foundation
import SwiftData

enum MeasurementUnit: String, Identifiable {

    static let conversionConstant: Float = 18.0182

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

        @Published var measurements = [Measurement]()

        var average: Float?
        @Published var averageText = ""
        @Published var selectedMeasurementUnit: MeasurementUnit = .mgdl
        @Published var showsAllMeasurements = false
        @Published var textInput = ""
        @Published var showsAlert = false
        var alertMessage = ""

        // MARK: Swift Data
        let modelContext: ModelContext

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }

        func fetchData() {
            do {
                let descriptor = FetchDescriptor<Measurement>(sortBy: [SortDescriptor(\.date)])
                self.measurements = try modelContext.fetch(descriptor)
            } catch {
                showAlert(with: "Can't fetch measurements data")
            }
        }

        func save() {
            guard textInput.isEmpty, let number = parseDecimal(from: textInput) else {
                showAlert(with: "Not a valid number")
                return
            }

            let floatValue = NSDecimalNumber(decimal: number).floatValue
            if floatValue < 0 {
                showAlert(with: "Not a valid number")
                return
            }

            addMeasurement(value: floatValue)

            // Reset the input value
            textInput = ""

            calculateAverage()
            updateAverageText()
        }

        private func addMeasurement(value: Float) {
            // always add measurements in mg/dl unit
            let value = selectedMeasurementUnit == .mgdl ? value : value / MeasurementUnit.conversionConstant
            let measurement = Measurement(value: value)
            modelContext.insert(measurement)

            fetchData()
        }

        func calculateAverage() {
            average = measurements.reduce(0, { partialResult, measurement in
                partialResult + measurement.value
            }) / Float(measurements.count)
        }

        func updateAverageText() {
            guard let average = average else { return }

            if let formattedNumber = NumberFormatter.measurement.string(from: average as NSNumber) {
                averageText = formattedNumber
            }
        }

        private func parseDecimal(from string: String) -> Decimal? {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale.current

            if let number = formatter.number(from: string) {
                return number.decimalValue
            }
            return nil
        }

        private func showAlert(with text: String) {
            alertMessage = text
            showsAlert = true
            return
        }

        func showAllMeasurements() {
            showsAllMeasurements = true
        }

        func didChangeMeasurementUnit() {
            guard let average else { return }

            switch selectedMeasurementUnit {
                case .mgdl:
                    self.average = average * MeasurementUnit.conversionConstant
                case .mmoll:
                    self.average = average / MeasurementUnit.conversionConstant
            }

            updateAverageText()
        }
    }
}
