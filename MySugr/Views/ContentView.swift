//
//  ContentView.swift
//  MySugr
//
//  Created by Tomas Bobko on 27.09.24.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = ContentView.ViewModel()
    @StateObject var measurementsViewModel = MeasurementsView.ViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if let _ = viewModel.average {
                    Text("Your average is: \(viewModel.averageText)" +  " " + viewModel.selectedMeasurementUnit.rawValue)
                }

                Divider()

                HStack {
                    Text("Add measurement:")
                    Spacer()
                }

                Picker("Select measurement", selection: $viewModel.selectedMeasurementUnit) {
                    ForEach(MeasurementUnit.allCases) { measurement in
                        Text(measurement.rawValue)
                    }
                }
                .onChange(of: viewModel.selectedMeasurementUnit, { oldValue, newValue in
                    viewModel.didChangeMeasurementUnit()
                })
                .pickerStyle(.segmented)
                .frame(width: 200)

                HStack(alignment: .firstTextBaseline, spacing: 20) {
                    TextField("Input measurement here", text: $viewModel.textInput)
                        .textFieldStyle(.roundedBorder).padding(.top, 20)
                        .keyboardType(.decimalPad)

                    Text(viewModel.selectedMeasurementUnit.rawValue)
                }

                Spacer()

                Button("Save") {
                    viewModel.save()
                }
                .disabled(viewModel.textInput.isEmpty)
            }
            .navigationTitle("Mini Logbook")
            .padding()
            .alert(viewModel.alertMessage, isPresented: $viewModel.showsAlert, actions: {} )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showAllMeasurements()
                    } label: {
                        Image(systemName: "tray.full")
                    }
                }
            }
            .onChange(of: viewModel.measurements, { oldValue, newValue in
                measurementsViewModel.measurements = newValue
            })
            .sheet(isPresented: $viewModel.showsAllMeasurements) {
                NavigationStack {
                    MeasurementsView(viewModel: measurementsViewModel)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Close") {
                                    viewModel.showsAllMeasurements = false
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
