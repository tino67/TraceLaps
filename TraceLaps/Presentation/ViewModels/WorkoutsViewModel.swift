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
    private let getWorkoutsUseCase: GetWorkouts
    private let saveWorkoutUseCase: SaveWorkout
    private let healthKitManager: HealthKitManager

    @Published var workouts: [Workout] = []
    @Published var healthKitWorkouts: [HKWorkout] = []
    @Published var isHealthKitAuthorized = false
    @Published var path = [MainCoordinator.Destination]()

    init(getWorkoutsUseCase: GetWorkouts, saveWorkoutUseCase: SaveWorkout, healthKitManager: HealthKitManager) {
        self.getWorkoutsUseCase = getWorkoutsUseCase
        self.saveWorkoutUseCase = saveWorkoutUseCase
        self.healthKitManager = healthKitManager
        requestHealthKitAuthorization()
    }

    func getWorkouts() async {
        do {
            workouts = try await getWorkoutsUseCase.execute()
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
            let existingWorkouts = try await getWorkoutsUseCase.execute()
            if !existingWorkouts.contains(where: { $0.id == hkWorkout.uuid }) {
                let workout = Workout(
                    id: hkWorkout.uuid,
                    date: hkWorkout.endDate,
                    duration: hkWorkout.duration,
                    distance: hkWorkout.totalDistance?.doubleValue(for: .meter()) ?? 0,
                    calories: hkWorkout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                    locations: []
                )
                try await saveWorkoutUseCase.execute(workout)
                await getWorkouts()
            }
        }
    }

    func workoutTapped(workout: Workout) {
        path.append(.detail(workout))
    }
}
