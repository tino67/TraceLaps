//
//  WorkoutLocalDataSource.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftData
import Entities

public protocol WorkoutLocalDataSource {
    func getWorkouts() async throws -> [Workout]
    func saveWorkout(_ workout: Workout) async throws
    func delete(workout: Workout) async throws
}
