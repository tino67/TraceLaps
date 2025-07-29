//
//  WorkoutDetailViewModel.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftUI

class WorkoutDetailViewModel: ObservableObject {
    @Published var workout: Workout

    init(workout: Workout) {
        self.workout = workout
    }
}
