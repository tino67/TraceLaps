//
//  WorkoutRepositoryImpl.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import Entities
import RepositoryInterfaces
import DataSourceInterfaces
import SwiftData
internal import Dependencies

public class WorkoutRepositoryImpl: WorkoutRepository {
    @Dependency(\.workoutLocalDataSource) private var workoutLocalDataSource

    public init() {}

    public func start(modelContext: ModelContext) {
        workoutLocalDataSource.start(modelContext: modelContext)
    }

    public func getWorkouts() async throws -> [Workout] {
        try await workoutLocalDataSource.getWorkouts()
    }

    public func saveWorkout(_ workout: Workout) async throws {
        try await workoutLocalDataSource.saveWorkout(workout)
    }

    public func delete(workout: Workout) async throws {
        try await workoutLocalDataSource.delete(workout: workout)
    }
}
