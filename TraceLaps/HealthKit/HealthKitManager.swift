//
//  HealthKitManager.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import HealthKit
import CoreLocation

class HealthKitManager {
    private let healthStore = HKHealthStore()
    private let typesToReadMandatory: Set = [
        HKSeriesType.workoutRoute(),
        .workoutType()
    ]

    enum HealthKitError: Error {
        case notAvailable
        case AuthorizationStatusNotDetermined
        case AuthorizationStatusDenied
    }

    enum AuthorizationStatus {
        fileprivate init(_ status: HKAuthorizationStatus) {
            switch status {
            case .notDetermined:
                self = .notDetermined
            case .sharingDenied:
                self = .denied
            case .sharingAuthorized:
                self = .authorized
            @unknown default:
                self = .notDetermined
            }
        }

        case notDetermined, denied, authorized, notAvailable
    }

    func authorizationStatus() -> AuthorizationStatus {
        guard HKHealthStore.isHealthDataAvailable() else {
            return .notAvailable
        }

        let authorizations: Set<HKAuthorizationStatus> = Set(typesToReadMandatory
            .map { healthStore.authorizationStatus(for: $0) })

        var status: AuthorizationStatus = .notDetermined
        if authorizations.count == 1, let hkStatus = authorizations.first {
            status = AuthorizationStatus(hkStatus)
        } else {
            status = .denied
        }

        return status
    }

    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
             throw HealthKitError.notAvailable
        }
        try await healthStore.requestAuthorization(toShare: [], read: typesToReadMandatory)
    }

    func fetchWorkouts(completion: @escaping ([HKWorkout]?, Error?) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(sampleType: .workoutType(), predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, error in
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
                    if let _ = samples?.first as? HKWorkoutRoute, error == nil {
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

    func fetchRoute(for workout: HKWorkout) async throws -> [CLLocation] {
        let route = try await loadRoute(for: workout)
        guard let route else { return [] }

        return try await withCheckedThrowingContinuation { continuation in
            var allLocations: [CLLocation] = []
            let query = HKWorkoutRouteQuery(route: route) { _, locs, done, error in
                if let locs = locs { allLocations.append(contentsOf: locs) }
                if done {
                    continuation.resume(returning: allLocations)
                } else if let error = error {
                    continuation.resume(throwing: error)
                }
            }
            healthStore.execute(query)
        }
    }
}

private extension HealthKitManager {
    func loadRoute(for workout: HKWorkout) async throws -> HKWorkoutRoute? {
        let predicate = HKQuery.predicateForObjects(from: workout)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: HKSeriesType.workoutRoute(),
                predicate: predicate,
                limit: 1,
                sortDescriptors: nil
            ) { _, samples, _ in
                continuation.resume(returning: samples?.first as? HKWorkoutRoute)
            }
            healthStore.execute(query)
        }
    }
}
