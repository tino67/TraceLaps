//
//  WorkoutLocalDataSourceKey.swift
//  Repositories
//
//  Created by Quentin Noblet on 15/09/2025.
//

import DataSourceInterfaces
import LocalDataSource
internal import Dependencies

private enum WorkoutLocalDataSourceKey: DependencyKey {
    static let liveValue: any WorkoutLocalDataSource = WorkoutLocalDataSourceImpl()
}

extension DependencyValues {
    var workoutLocalDataSource: any WorkoutLocalDataSource {
        get { self[WorkoutLocalDataSourceKey.self] }
        set { self[WorkoutLocalDataSourceKey.self] = newValue }
    }
}
