//
//  Start.swift
//  TraceLaps
//
//  Created by Quentin Noblet on 15/09/2025.
//

import SwiftData
import Repositories
internal import Dependencies

extension UseCase {
    public class Start {
        @Dependency(\.workoutRepository) private var workoutRepository

        public init() {}

        public func call(_ modelContext: ModelContext) {
            workoutRepository.start(modelContext: modelContext)
        }
    }
}
