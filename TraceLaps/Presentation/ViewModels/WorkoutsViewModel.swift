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
                let mappedWorkouts = workouts.map { workout in
                    Workout(id: workout.uuid, date: workout.endDate, duration: workout.duration, distance: workout.totalDistance?.doubleValue(for: .meter()) ?? 0, calories: workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0)
                }
                DispatchQueue.main.async {
                    self?.workouts = mappedWorkouts
                }
            }
        }
    }
}
