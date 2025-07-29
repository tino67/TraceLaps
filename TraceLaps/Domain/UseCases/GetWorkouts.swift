//
//  GetWorkouts.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation

protocol GetWorkoutsUseCase {
    func call() async throws -> [Workout]
}

struct GetWorkouts: GetWorkoutsUseCase {
    let workoutRepository: WorkoutRepository

    func call() async throws -> [Workout] {
        try await workoutRepository.getWorkouts()
    }
}
