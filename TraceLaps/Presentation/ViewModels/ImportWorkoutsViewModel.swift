//
//  ImportWorkoutsViewModel.swift
//  TraceLaps
//
//  Created by Quentin Noblet on 30/07/2025.
//

import HealthKit
import UseCases
import Entities

@MainActor
final class ImportWorkoutsViewModel: ObservableObject {
    // MARK: UseCases
    private let getWorkoutsUseCase: UseCase.GetWorkouts
    private let saveWorkoutUseCase: UseCase.SaveWorkout
    private let healthKitManager: HealthKitManager

    // MARK: Model
    enum ViewState {
        case loading
        case data(_ workouts: [(workout: HKWorkout, isAlreadyImported: Bool)], _ authorizationStatus: HealthKitManager.AuthorizationStatus)
        case error(Error)
    }

    enum ViewError: Error {
        case noData
        case heathKitError(HealthKitManager.HealthKitError)
    }

    @Published var viewState: ViewState = .loading

    init(
        getWorkoutsUseCase: UseCase.GetWorkouts,
        saveWorkoutUseCase: UseCase.SaveWorkout,
        healthKitManager: HealthKitManager
    ) {
        self.getWorkoutsUseCase = getWorkoutsUseCase
        self.saveWorkoutUseCase = saveWorkoutUseCase
        self.healthKitManager = healthKitManager
    }

    func requestHealthKitAuthorization() async throws {
        try await healthKitManager.requestAuthorization()
        try await fetchWorkouts()
    }

    private func fetchWorkouts() async throws {
        do {
            let existingWorkouts = try await getWorkoutsUseCase.call()
            let workouts = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKWorkout], Error>) in
                healthKitManager.fetchWorkouts { workouts, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else if let workouts {
                        continuation.resume(returning: workouts)
                    } else {
                        continuation.resume(returning: [])
                    }
                }
            }

            let result: [(workout: HKWorkout, isAlreadyImported: Bool)] = workouts.map { workout in
                let isAlreadyImported: Bool = existingWorkouts.contains(where: { $0.importId == workout.uuid })
                return (workout, isAlreadyImported)
            }

            viewState = .data(result, healthKitManager.authorizationStatus)
        } catch {
            viewState = .error(error)
        }
    }

    func save(hkWorkout: HKWorkout) {
        Task { @MainActor in
            let existingWorkouts = try await getWorkoutsUseCase.call()
            if !existingWorkouts.contains(where: { $0.importId == hkWorkout.uuid }) {
                let locations = try await healthKitManager.fetchRoute(for: hkWorkout)
                let calories = hkWorkout.statistics(for: .init(.activeEnergyBurned))?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0

                let workout = Workout(
                    id: UUID(),
                    importId: hkWorkout.uuid,
                    date: hkWorkout.endDate,
                    duration: hkWorkout.duration,
                    distance: hkWorkout.totalDistance?.doubleValue(for: .meter()) ?? 0,
                    calories: calories,
                    type: WorkoutType(from: hkWorkout.workoutActivityType),
                    locations: locations.map { .init(from: $0) }
                )
                try await saveWorkoutUseCase.call(workout)
            }
        }
    }

}
