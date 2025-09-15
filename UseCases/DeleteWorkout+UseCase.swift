//
//  DeleteWorkoutUseCase.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation

extension UseCase {
    public class DeleteWorkout {
        private let workoutRepository: WorkoutRepository

        public init(workoutRepository: WorkoutRepository) {
            self.workoutRepository = workoutRepository
        }

        public func call(_ workout: Workout) async throws {
            try await workoutRepository.delete(workout: workout)
        }
    }
}
