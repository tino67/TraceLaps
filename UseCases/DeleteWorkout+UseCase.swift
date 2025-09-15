//
//  DeleteWorkoutUseCase.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import Entities
import RepositoryInterfaces
internal import Dependencies

extension UseCase {
    public class DeleteWorkout {
        @Dependency(\.workoutRepository) private var workoutRepository

        public init() {}

        public func call(_ workout: Workout) async throws {
            try await workoutRepository.delete(workout: workout)
        }
    }
}
