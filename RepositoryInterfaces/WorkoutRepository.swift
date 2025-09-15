//
//  WorkoutRepository.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import Entities
import SwiftData

public protocol WorkoutRepository {
    func start(modelContext: ModelContext)
    func getWorkouts() async throws -> [Workout]
    func saveWorkout(_ workout: Workout) async throws
    func delete(workout: Workout) async throws
}
