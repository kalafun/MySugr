//
//  ContentView.swift
//  MySugr
//
//  Created by Tomas Bobko on 27.09.24.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = ContentView.ViewModel()

    var body: some View {
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
        .padding()
        .alert(viewModel.alertMessage, isPresented: $viewModel.showsAlert, actions: {} )
    }
}

#Preview {
    ContentView()
}