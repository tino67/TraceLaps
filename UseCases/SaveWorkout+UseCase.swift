//
//  SaveWorkoutUseCase.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation

extension UseCase {
    public struct SaveWorkout: SaveWorkoutUseCase {
        let workoutRepository: WorkoutRepository

        public func call(_ workout: Workout) async throws {
            try await workoutRepository.saveWorkout(workout)
        }
    }
}

