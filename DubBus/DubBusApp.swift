//
//  DubBusApp.swift
//  DubBus
//
//

import SwiftUI
import SwiftData

@main
struct DubBusApp: App {
    // Define the container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([BusStop.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Seed data on first launch
                    DataHandler.seedStopsIfEmpty(context: sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer) // Inject the container
    }
}
