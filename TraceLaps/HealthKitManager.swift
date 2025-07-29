//
//  HealthKitManager.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitError.notAvailable)
            return
        }

        let typesToRead: Set = [
            HKObjectType.workoutType(),
            HKSeriesType.workoutRoute()
        ]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            completion(success, error)
        }
    }

    func fetchWorkouts(completion: @escaping ([HKWorkout]?, Error?) -> Void) {
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(sampleType: .workoutType(), predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let workouts = samples as? [HKWorkout] else {
                completion(nil, error)
                return
            }

            let group = DispatchGroup()
            var workoutsWithRoutes: [HKWorkout] = []

            for workout in workouts {
                group.enter()
                let routeQuery = HKQuery.predicateForObjects(from: workout)
                let routeQuerySample = HKSampleQuery(sampleType: HKSeriesType.workoutRoute(), predicate: routeQuery, limit: 1, sortDescriptors: nil) { _, samples, error in
                    if let route = samples?.first as? HKWorkoutRoute, error == nil {
                        workoutsWithRoutes.append(workout)
                    }
                    group.leave()
                }
                self.healthStore.execute(routeQuerySample)
            }

            group.notify(queue: .main) {
                completion(workoutsWithRoutes, nil)
            }
        }
        healthStore.execute(query)
    }
}

enum HealthKitError: Error {
    case notAvailable
}
