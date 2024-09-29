//
//  MeasurementsTest.swift
//  MySugrTests
//
//  Created by Tomas Bobko on 29.09.24.
//

import XCTest
import SwiftUI
@testable import MySugr

class MeasurementsTest: XCTestCase {

    var viewModel: MeasurementsView.ViewModel!

    override func setUp() async throws {

        await MainActor.run {
            viewModel = MeasurementsView.ViewModel(
                measurements: [
                    Measurement(value: 5),
                    Measurement(value: 10),
                    Measurement(value: 15)
                ]
            )
        }
    }

    override func tearDown() {
        viewModel = nil
    }

    @MainActor
    func testMeasurementsCount() {
        let measurementsView = MeasurementsView(viewModel: viewModel)

        XCTAssertEqual(
            measurementsView.viewModel.measurements.count, 3, "The view model should have three measurements."
        )
    }

    @MainActor
    func testEmptyState() {
        viewModel.measurements = []

        XCTAssertTrue(viewModel.measurements.isEmpty, "The measurements array should be empty.")
    }

    @MainActor
    func testCreatingMockedMeasurements() {
        let measurements = Measurement.mocked(count: 20)

        XCTAssertTrue(measurements.count == 20)
    }

    @MainActor
    func testStringFromMeasurementValue() {
        XCTAssertEqual(MeasurementUnit.mgdl.stringFrom(value: 3.3), "3,3 mg/dL")
    }
}
