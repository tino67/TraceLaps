//
//  Workout.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftData

@Model
final class Workout {
    var id: UUID
    var date: Date
    var duration: TimeInterval
    var distance: Double
    var calories: Double

    init(id: UUID, date: Date, duration: TimeInterval, distance: Double, calories: Double) {
        self.id = id
        self.date = date
        self.duration = duration
        self.distance = distance
        self.calories = calories
    }
}
