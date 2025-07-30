//
//  WorkoutsViewModel.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftUI
import HealthKit

@MainActor
class WorkoutsViewModel: ObservableObject {
    private let getWorkoutsUseCase: GetWorkoutsUseCase
    private let saveWorkoutUseCase: SaveWorkout
    private let deleteWorkoutUseCase: DeleteWorkout
    private let healthKitManager: HealthKitManager

    @Published var workouts: [Workout] = []
    @Published var healthKitWorkouts: [HKWorkout] = []
    @Published var savedWorkoutIDs = Set<UUID>()
    @Published var isHealthKitAuthorized = false
    @Published var path = [MainCoordinator.Destination]()

    init(
        getWorkoutsUseCase: GetWorkoutsUseCase,
        saveWorkoutUseCase: SaveWorkout,
        deleteWorkoutUseCase: DeleteWorkout,
        healthKitManager: HealthKitManager
    ) {
        self.getWorkoutsUseCase = getWorkoutsUseCase
        self.saveWorkoutUseCase = saveWorkoutUseCase
        self.deleteWorkoutUseCase = deleteWorkoutUseCase
        self.healthKitManager = healthKitManager
        requestHealthKitAuthorization()
    }

    func getWorkouts() async {
        do {
            let savedWorkouts = try await getWorkoutsUseCase.call()
            DispatchQueue.main.async {
                self.workouts = savedWorkouts
                self.savedWorkoutIDs = Set(savedWorkouts.map { $0.id })
            }
        } catch {
            // Handle error
        }
    }

    private func requestHealthKitAuthorization() {
        healthKitManager.requestAuthorization { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.isHealthKitAuthorized = true
                    self?.fetchWorkouts()
                } else {
                    // Handle error or denial
                }
            }
        }
    }

    private func fetchWorkouts() {
        healthKitManager.fetchWorkouts { [weak self] workouts, error in
            if let workouts = workouts {
                DispatchQueue.main.async {
                    self?.healthKitWorkouts = workouts
                }
            }
        }
    }

    func save(hkWorkout: HKWorkout) {
        Task {
            let existingWorkouts = try await getWorkoutsUseCase.call()
            if !existingWorkouts.contains(where: { $0.importId == hkWorkout.uuid }) {
                let locations = try await healthKitManager.fetchRoute(for: hkWorkout)

                let workout = Workout(
                    id: UUID(),
                    importId: hkWorkout.uuid,
                    date: hkWorkout.endDate,
                    duration: hkWorkout.duration,
                    distance: hkWorkout.totalDistance?.doubleValue(for: .meter()) ?? 0,
                    calories: hkWorkout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                    type: WorkoutType(hkWorkoutActivityType: hkWorkout.workoutActivityType),
                    locations: locations.map { .init(from: $0) }
                )
                try await saveWorkoutUseCase.call(workout)
                DispatchQueue.main.async {
                    self.workouts.append(workout)
                }
            }
        }
    }
    
    func workoutTapped(workout: Workout) {
        path.append(.detail(workout))
    }

    func delete(at offsets: IndexSet) {
        let workoutsToDelete = offsets.map { workouts[$0] }
        Task {
            for workout in workoutsToDelete {
                try await deleteWorkoutUseCase.call(workout)
            }
            DispatchQueue.main.async {
                self.workouts.remove(atOffsets: offsets)
            }
        }
    }
}
