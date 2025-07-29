//
//  WorkoutRepositoryImpl.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation

struct WorkoutRepositoryImpl: WorkoutRepository {
    let localDataSource: WorkoutLocalDataSource

    func getWorkouts() async throws -> [Workout] {
        try await localDataSource.getWorkouts()
    }

    func saveWorkout(_ workout: Workout) async throws {
        try await localDataSource.saveWorkout(workout)
    }
}
