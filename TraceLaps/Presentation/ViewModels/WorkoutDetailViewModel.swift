//
//  WorkoutDetailViewModel.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftUI

class WorkoutDetailViewModel: ObservableObject {
    @Published var workout: Workout
    private let deleteWorkoutUseCase: DeleteWorkout

    init(workout: Workout, deleteWorkoutUseCase: DeleteWorkout) {
        self.workout = workout
        self.deleteWorkoutUseCase = deleteWorkoutUseCase
    }

    func deleteWorkout() async {
        try? await deleteWorkoutUseCase.call(workout)
    }
}
