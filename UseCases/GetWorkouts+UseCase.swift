//
//  GetWorkoutsUseCase.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import Entities
import RepositoryInterfaces
internal import Dependencies

extension UseCase {
    public struct GetWorkouts {
        @Dependency(\.workoutRepository) private var workoutRepository

        public init() {}

        public func call() async throws -> [Workout] {
            try await workoutRepository.getWorkouts()
        }
    }
}
