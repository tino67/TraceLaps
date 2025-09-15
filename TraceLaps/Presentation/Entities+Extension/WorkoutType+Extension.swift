//
//  WorkoutType+extension.swift
//  TraceLaps
//
//  Created by Quentin Noblet on 30/07/2025.
//

import Entities
import HealthKit

extension WorkoutType {
    init(from hkWorkoutActivityType: HKWorkoutActivityType) {
        if let workoutType = WorkoutType(rawValue: Int(hkWorkoutActivityType.rawValue)) {
            self = workoutType
        } else {
            self = .other
        }
    }
}
