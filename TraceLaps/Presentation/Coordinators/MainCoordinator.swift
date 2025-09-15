//
//  MainCoordinator.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftUI
import SwiftData
import Entities
import UseCases

class MainCoordinator: Coordinator {

    enum Destination: Hashable {
        case detail(Workout)
    }

    @ViewBuilder
    func start() -> AnyView {
        AnyView(buildWorkoutsView())
    }

    @ViewBuilder
    private func buildWorkoutsView() -> some View {
        let viewModel: WorkoutsViewModel = .init(
            getWorkoutsUseCase: UseCase.GetWorkouts(),
            saveWorkoutUseCase: UseCase.SaveWorkout(),
            deleteWorkoutUseCase: UseCase.DeleteWorkout()
        )

        WorkoutsView(viewModel: viewModel, coordinator: self)
    }

    @ViewBuilder
    func view(for destination: Destination) -> some View {
        switch destination {
        case .detail(let workout):
            let viewModel: WorkoutDetailViewModel = .init(workout: workout, deleteWorkoutUseCase: UseCase.DeleteWorkout())
            WorkoutDetailView(viewModel: viewModel)
        }
    }
}
