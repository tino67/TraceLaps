//
//  WorkoutRepositoryImpl.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation

class WorkoutRepositoryImpl: WorkoutRepository {
    let localDataSource: WorkoutLocalDataSource

    init(localDataSource: WorkoutLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func getWorkouts() async throws -> [Workout] {
        try await localDataSource.getWorkouts()
    }

    func saveWorkout(_ workout: Workout) async throws {
        try await localDataSource.saveWorkout(workout)
    }

    func delete(workout: Workout) async throws {
        try await localDataSource.delete(workout: workout)
    }
}
