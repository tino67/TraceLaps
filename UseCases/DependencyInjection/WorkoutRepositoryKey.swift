//
//  WorkoutRepositoryKey.swift
//  UseCases
//
//  Created by Quentin Noblet on 15/09/2025.
//

import RepositoryInterfaces
import Repositories
internal import Dependencies

private enum WorkoutRepositoryKey: DependencyKey {
    static let liveValue: any WorkoutRepository = WorkoutRepositoryImpl()
}

extension DependencyValues {
    var workoutRepository: any WorkoutRepository {
        get { self[WorkoutRepositoryKey.self] }
        set { self[WorkoutRepositoryKey.self] = newValue }
    }
}
