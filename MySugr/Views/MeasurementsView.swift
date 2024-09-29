//
//  MeasurementsView.swift
//  MySugr
//
//  Created by Tomas Bobko on 27.09.24.
//

import SwiftUI

struct MeasurementsView: View {

    @ObservedObject var viewModel: MeasurementsView.ViewModel

    var body: some View {
        VStack {
            if viewModel.measurements.count > 0 {
                HStack(spacing: 4) {
                    Text("You have")
                    Text("\(viewModel.measurements.count) measurements")
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
            }

            List {
                ForEach(viewModel.measurements, id: \.id) { measurement in
                    HStack(alignment: .bottom) {
                        Text(viewModel.measurementUnit.stringFrom(value: measurement.value))

                        Spacer()
                        Text(measurement.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
        .overlay {
            if viewModel.measurements.isEmpty {
                VStack(alignment: .center, spacing: 16) {
                    Text("You have no measurements yet")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Go back and add some :)")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .font(.title3)
                }
                .padding()
            }
        }
        .navigationTitle("All measurements")
    }
}

#Preview {
    NavigationStack {
        MeasurementsView(
            viewModel: MeasurementsView.ViewModel(
                measurements: Measurement.mocked(count: 10),
                measurementUnit: .mgdl
            )
        )
    }
}

extension MeasurementsView {

    @MainActor
    class ViewModel: ObservableObject {
        @Published var measurements = [Measurement]()
        @Published var measurementUnit: MeasurementUnit

        init(measurements: [Measurement] = [], measurementUnit: MeasurementUnit = .mgdl) {
            self.measurements = measurements
            self.measurementUnit = measurementUnit
        }
    }
}
