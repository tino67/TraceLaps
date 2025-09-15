struct ImportWorkoutsViewModel {
    


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
                DispatchQueue.main.async {
                    self?.healthKitWorkouts = workouts
                }
            }
        }
    }

    func save(hkWorkout: HKWorkout) {
        Task {
            let existingWorkouts = try await getWorkoutsUseCase.call()
            if !existingWorkouts.contains(where: { $0.importId == hkWorkout.uuid }) {
                let locations = try await healthKitManager.fetchRoute(for: hkWorkout)

                let workout = Workout(
                    id: UUID(),
                    importId: hkWorkout.uuid,
                    date: hkWorkout.endDate,
                    duration: hkWorkout.duration,
                    distance: hkWorkout.totalDistance?.doubleValue(for: .meter()) ?? 0,
                    calories: hkWorkout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                    type: WorkoutType(hkWorkoutActivityType: hkWorkout.workoutActivityType),
                    locations: locations.map { .init(from: $0) }
                )
                try await saveWorkoutUseCase.call(workout)
                DispatchQueue.main.async {
                    self.workouts.append(workout)
                }
            }
        }
    }

}