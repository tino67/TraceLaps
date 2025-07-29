//
//  WorkoutsViewModel.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftUI

@MainActor
class WorkoutsViewModel: ObservableObject {
    private let getWorkoutsUseCase: GetWorkoutsUseCase
    private let saveWorkoutUseCase: SaveWorkoutUseCase
    private let healthKitManager = HealthKitManager()

    @Published var workouts: [Workout] = []
    @Published var healthKitWorkouts: [HKWorkout] = []
    @Published var isHealthKitAuthorized = false

    init(getWorkoutsUseCase: GetWorkoutsUseCase, saveWorkoutUseCase: SaveWorkoutUseCase) {
        self.getWorkoutsUseCase = getWorkoutsUseCase
        self.saveWorkoutUseCase = saveWorkoutUseCase
        requestHealthKitAuthorization()
    }

    func getWorkouts() async {
        do {
            workouts = try await getWorkoutsUseCase.call()
        } catch {
            // Handle error
        }
    }

    func addWorkout() async {
        let newWorkout = Workout(id: UUID(), date: Date(), duration: .random(in: 1000...5000), distance: .random(in: 1...10), calories: .random(in: 100...500))
        do {
            try await saveWorkoutUseCase.call(newWorkout)
            await getWorkouts()
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
            if !existingWorkouts.contains(where: { $0.id == hkWorkout.uuid }) {
                let workout = Workout(id: hkWorkout.uuid, date: hkWorkout.endDate, duration: hkWorkout.duration, distance: hkWorkout.totalDistance?.doubleValue(for: .meter()) ?? 0, calories: hkWorkout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0)
                try await saveWorkoutUseCase.call(workout)
                DispatchQueue.main.async {
                    self.workouts.append(workout)
                }
            }
        }
    }
}
