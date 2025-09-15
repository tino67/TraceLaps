//
//  WorkoutLocalDataSourceImpl.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftData
import Entities
import DataSourceInterfaces

public class WorkoutLocalDataSourceImpl: WorkoutLocalDataSource {
    private var modelContext: ModelContext?

    public init() {}

    public func start(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func getWorkouts() async throws -> [Workout] {
        guard let modelContext else { fatalError(#function + ": modelContext is nil") }
        let descriptor = FetchDescriptor<Workout>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }

    public func saveWorkout(_ workout: Workout) async throws {
        guard let modelContext else { fatalError(#function + ": modelContext is nil") }
        modelContext.insert(workout)
        try modelContext.save()
    }

    public func delete(workout: Workout) async throws {
        guard let modelContext else { fatalError(#function + ": modelContext is nil") }
        modelContext.delete(workout)
    }
}
