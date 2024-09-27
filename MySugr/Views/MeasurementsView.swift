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
                }
            }

            List {
                ForEach(viewModel.measurements, id: \.id) { measurement in
                    Text(viewModel.stringFromMeasurement(measurement))
                }
            }
        }
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
                measurements: Measurement.mocked(count: 0)
            )
        )
    }
}

extension MeasurementsView {

    @MainActor
    class ViewModel: ObservableObject {
        @Published var measurements = [Measurement]()

        init(measurements: [Measurement] = []) {
            self.measurements = measurements
        }

        func stringFromMeasurement(_ measurement: Measurement) -> String {
            NumberFormatter.measurement.string(from: NSNumber(value: measurement.value)) ?? ""
        }
    }
}
