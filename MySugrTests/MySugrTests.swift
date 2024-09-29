//
//  MySugrTests.swift
//  MySugrTests
//
//  Created by Tomas Bobko on 27.09.24.
//

import XCTest
import SwiftData
@testable import MySugr

fileprivate let testContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Measurement.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )

        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

class MySugrTests: XCTestCase {

    var viewModel: ContentView.ViewModel!

    override func setUp() async throws {
        try await super.setUp()

        await MainActor.run {
            viewModel = ContentView.ViewModel(modelContext: testContainer.mainContext)
        }
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    @MainActor
    func testCalculateAverage() {

        let measurements = [
            Measurement(value: 5),
            Measurement(value: 10),
            Measurement(value: 15)
        ]
        viewModel.measurements = measurements
        viewModel.calculateAverage()

        XCTAssertEqual(viewModel.average, 10.0, "Average calculation is incorrect.")
    }

    @MainActor
    func testSaveValidMeasurement() {

        viewModel.textInput = "3,2"
        viewModel.save()

        XCTAssertEqual(viewModel.measurements.count, 1)
        XCTAssertEqual(viewModel.measurements.first?.value, 3.2)
    }

    @MainActor
    func testSaveEmptyMeasurement() {
        viewModel.textInput = ""
        viewModel.save()

        XCTAssertTrue(viewModel.measurements.isEmpty)
        XCTAssertEqual(viewModel.showsAlert, true)
        XCTAssertEqual(viewModel.alertMessage, "Not a valid number")
    }

    @MainActor
    func testSaveInvalidMeasurement() {
        viewModel.textInput = "abc"
        viewModel.save()

        XCTAssertTrue(viewModel.measurements.isEmpty)
        XCTAssertEqual(viewModel.showsAlert, true)
        XCTAssertEqual(viewModel.alertMessage, "Not a valid number")
    }

    @MainActor
    func testMeasurementUnitConversionToMgdl() {
        viewModel.selectedMeasurementUnit = .mgdl
        viewModel.average = 216

        viewModel.selectedMeasurementUnit = .mmoll
        viewModel.didChangeMeasurementUnit()

        XCTAssertEqual(viewModel.average, 216 / MeasurementUnit.conversionConstant)
    }
}
