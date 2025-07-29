//
//  DeleteWorkoutUseCase.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation

protocol DeleteWorkout {
    func call(_ workout: Workout) async throws
}

class DeleteWorkoutUseCase: DeleteWorkout {
    private let workoutRepository: WorkoutRepository

    init(workoutRepository: WorkoutRepository) {
        self.workoutRepository = workoutRepository
    }

    func call(_ workout: Workout) async throws {
        try await workoutRepository.delete(workout: workout)
    }
}
