//
//  SaveWorkout.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation

protocol SaveWorkoutUseCase {
    func call(_ workout: Workout) async throws
}

struct SaveWorkout: SaveWorkoutUseCase {
    let workoutRepository: WorkoutRepository

    func call(_ workout: Workout) async throws {
        try await workoutRepository.saveWorkout(workout)
    }
}
