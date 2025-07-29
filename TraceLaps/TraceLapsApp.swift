//
//  TraceLapsApp.swift
//  TraceLaps
//
//  Created by Quentin Noblet on 29/07/2025.
//

import SwiftUI
import SwiftData

@main
struct TraceLapsApp: App {
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Workout.self,
            LocationPoint.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    private let coordinator = MainCoordinator()

    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
        .modelContainer(TraceLapsApp.sharedModelContainer)
    }
}
