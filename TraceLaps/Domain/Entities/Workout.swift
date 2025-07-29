//
//  Workout.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftData

@Model
final class Workout: Sendable {
    var id: UUID
    var date: Date
    var duration: TimeInterval
    var distance: Double
    var calories: Double
    var locations: [WorkoutLocation]

    init(id: UUID, date: Date, duration: TimeInterval, distance: Double, calories: Double, locations: [WorkoutLocation]) {
        self.id = id
        self.date = date
        self.duration = duration
        self.distance = distance
        self.calories = calories
        self.locations = locations
    }
}
