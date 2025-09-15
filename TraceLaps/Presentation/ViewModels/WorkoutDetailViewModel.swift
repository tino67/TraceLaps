//
//  WorkoutDetailViewModel.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftUI
import Entities
import UseCases

class WorkoutDetailViewModel: ObservableObject {
    // MARK: UseCases
    private let deleteWorkoutUseCase: UseCase.DeleteWorkout

    // MARK: Data
    @Published var workout: Workout

    // MARK: Init
    init(workout: Workout, deleteWorkoutUseCase: UseCase.DeleteWorkout) {
        self.workout = workout
        self.deleteWorkoutUseCase = deleteWorkoutUseCase
    }

    // MARK: Actions
    func deleteWorkout() async {
        try? await deleteWorkoutUseCase.call(workout)
    }
}
