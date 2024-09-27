//
//  MySugrApp.swift
//  MySugr
//
//  Created by Tomas Bobko on 27.09.24.
//

import SwiftUI
import SwiftData

@main
struct MySugrApp: App {

    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
                .modelContainer(container)
        }
    }

    init() {
        do {
            container = try ModelContainer(for: Measurement.self)
        } catch {
            fatalError("Failed to create ModelContainer for Measurement with error: \(error)")
        }
    }
}
