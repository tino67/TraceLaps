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
                } else {
                    // Handle error or denial
                }
            }
        }
    }
}
