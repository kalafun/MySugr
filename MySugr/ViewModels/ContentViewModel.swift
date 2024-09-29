//
//  ContentViewModel.swift
//  MySugr
//
//  Created by Tomas Bobko on 27.09.24.
//

import Foundation
import SwiftData

enum MeasurementUnit: String, Identifiable {

    private static let conversionConstant: Float = 18.0182

    var id: Self { self }

    case mgdl = "mg/dL"
    case mmoll = "mmol/L"

    static var allCases: [Self] = {
        [mgdl, mmoll]
    }()

    private static func convertToMgdl(value: Float) -> Float {
        value * conversionConstant
    }

    static func convertToMmoll(value: Float) -> Float {
        value / conversionConstant
    }

    func stringFrom(value: Float) -> String {
        var measurementValue: Float = value

        switch self {
            case .mgdl:
                measurementValue = MeasurementUnit.convertToMgdl(value: value)
            case .mmoll:
                measurementValue = MeasurementUnit.convertToMmoll(value: value)
        }

        return (NumberFormatter.measurement.string(from: NSNumber(value: measurementValue)) ?? "") + " " + self.rawValue
    }
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
            guard !textInput.isEmpty, let number = parseDecimal(from: textInput) else {
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

        /// Adds measurement to SwiftData and fetches new data, always adds value in `mg/dl`
        /// - Parameter value: Float measurement value
        private func addMeasurement(value: Float) {
            // always add measurements in mg/dl unit
            let value = selectedMeasurementUnit == .mgdl ? value : MeasurementUnit.convertToMmoll(value: value)
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

            averageText = selectedMeasurementUnit.stringFrom(value: average)
        }

        private func parseDecimal(from string: String) -> Decimal? {
            if let number = NumberFormatter.measurement.number(from: string) {
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
            updateAverageText()
        }
    }
}
