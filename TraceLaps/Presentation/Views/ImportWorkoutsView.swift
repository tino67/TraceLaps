//
//  ImportWorkoutsView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI
import HealthKit

extension HKWorkout: Identifiable { }

struct ImportWorkoutsView: View {
    @ObservedObject var viewModel: WorkoutsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedWorkouts = Set<HKWorkout>()

    var body: some View {
        NavigationView {
            List(viewModel.healthKitWorkouts) { workout in
                let isSaved = viewModel.savedWorkoutIDs.contains(workout.id)
                HKWorkoutCellView(workout: workout, isSelected: selectedWorkouts.contains(workout), isSaved: isSaved) {
                    if !isSaved {
                        if selectedWorkouts.contains(workout) {
                            selectedWorkouts.remove(workout)
                        } else {
                            selectedWorkouts.insert(workout)
                        }
                    }
                }
                .disabled(isSaved)
            }
            .navigationTitle("Import Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        for workout in selectedWorkouts {
                            viewModel.save(hkWorkout: workout)
                        }
                        dismiss()
                    }
                    .disabled(selectedWorkouts.isEmpty)
                }
            }
        }
    }
}
