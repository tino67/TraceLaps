//
//  Workout.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftData

@Model
public final class Workout: Sendable {
    @Attribute(.unique) public var id: UUID
    public var importId: UUID?
    public var date: Date
    public var duration: TimeInterval
    public var distance: Double
    public var calories: Double
    public var type: WorkoutType
    public var locations: [LocationPoint]

    public init(id: UUID, importId: UUID? = nil, date: Date, duration: TimeInterval, distance: Double, calories: Double, type: WorkoutType, locations: [LocationPoint]) {
        self.id = id
        self.importId = importId
        self.date = date
        self.duration = duration
        self.distance = distance
        self.calories = calories
        self.type = type
        self.locations = locations
    }
}
