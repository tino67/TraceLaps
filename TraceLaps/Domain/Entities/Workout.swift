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
    @Attribute(.unique) var id: UUID
    var importId: UUID?
    var date: Date
    var duration: TimeInterval
    var distance: Double
    var calories: Double
    var locations: [LocationPoint]

    init(id: UUID, importId: UUID? = nil, date: Date, duration: TimeInterval, distance: Double, calories: Double, locations: [LocationPoint]) {
        self.id = id
        self.importId = importId
        self.date = date
        self.duration = duration
        self.distance = distance
        self.calories = calories
        self.locations = locations
    }
}
