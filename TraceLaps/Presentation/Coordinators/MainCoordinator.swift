//
//  MainCoordinator.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftUI
import SwiftData

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
        let getWorkoutsUseCase = GetWorkouts(workoutRepository: WorkoutRepositoryImpl(localDataSource: WorkoutLocalDataSourceImpl()))
        let saveWorkoutUseCase = SaveWorkout(workoutRepository: WorkoutRepositoryImpl(localDataSource: WorkoutLocalDataSourceImpl()))
        let deleteWorkoutUseCase = DeleteWorkoutUseCase(workoutRepository: WorkoutRepositoryImpl(localDataSource: WorkoutLocalDataSourceImpl()))

        let viewModel = WorkoutsViewModel(
            getWorkoutsUseCase: getWorkoutsUseCase,
            saveWorkoutUseCase: saveWorkoutUseCase,
            deleteWorkoutUseCase: deleteWorkoutUseCase,
            healthKitManager: HealthKitManager()
        )

        WorkoutsView(viewModel: viewModel, coordinator: self)
    }

    @ViewBuilder
    func view(for destination: Destination) -> some View {
        switch destination {
        case .detail(let workout):
            WorkoutDetailView(workout: workout)
        }
    }
}
