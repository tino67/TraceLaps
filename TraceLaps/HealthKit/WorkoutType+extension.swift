  init(hkWorkoutActivityType: HKWorkoutActivityType) {
        if let workoutType = WorkoutType(rawValue: Int(hkWorkoutActivityType.rawValue)) {
            self = workoutType
        } else {
            self = .other
        }
    }