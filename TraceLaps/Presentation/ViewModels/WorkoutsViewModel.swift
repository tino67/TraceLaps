//
//  WorkoutsViewModel.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftUI
import HealthKit
import Entities
import UseCases

@MainActor
final class WorkoutsViewModel: ObservableObject {
    // MARK: UseCases
    private let getWorkoutsUseCase: UseCase.GetWorkouts
    private let deleteWorkoutUseCase: UseCase.DeleteWorkout

    // MARK: Model
    enum ViewState {
        case loading
        case data(_ workouts: [Workout])
        case error(Error)
    }

    // MARK: Data
    @Published var state: ViewState = .loading
    @Published var path = [MainCoordinator.Destination]()

    // MARK: Init
    init(
        getWorkoutsUseCase: UseCase.GetWorkouts,
        saveWorkoutUseCase: UseCase.SaveWorkout,
        deleteWorkoutUseCase: UseCase.DeleteWorkout,
    ) {
        self.getWorkoutsUseCase = getWorkoutsUseCase
        self.deleteWorkoutUseCase = deleteWorkoutUseCase
    }

    // MARK: Actions
    @MainActor
    func getWorkouts() async {
        do {
            let savedWorkouts = try await getWorkoutsUseCase.call()
            state = .data(savedWorkouts)
        } catch {
            state = .error(error)
        }
    }

    func workoutTapped(workout: Workout) {
        path.append(.detail(workout))
    }

    func delete(workout: Workout) {
        guard case var .data(workouts) = state else {
            return
        }
        guard let index = workouts.firstIndex(of: workout) else {
            return
        }
        Task { @MainActor in
            try await deleteWorkoutUseCase.call(workout)
            workouts.remove(atOffsets: .init(integer: index))
            state = .data(workouts)
        }
    }
}
