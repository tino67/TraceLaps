//
//  GetWorkoutsUseCase.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation

extension UseCase {
    public struct GetWorkouts {
        let workoutRepository: WorkoutRepository

        public func call() async throws -> [Workout] {
            try await workoutRepository.getWorkouts()
        }
    }
}
