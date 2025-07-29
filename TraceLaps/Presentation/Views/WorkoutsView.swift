//
//  WorkoutsView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI

struct WorkoutsView: View {
    @StateObject var viewModel: WorkoutsViewModel

    var body: some View {
        List(viewModel.workouts) { workout in
            VStack(alignment: .leading) {
                Text("Duration: \(workout.duration)")
                    .font(.headline)
                Text("Distance: \(workout.distance)")
                    .font(.subheadline)
            }
        }
        .onAppear {
            Task {
                await viewModel.getWorkouts()
            }
        }
        .navigationTitle("Workouts")
        .toolbar {
            Button(action: {
                Task {
                    await viewModel.addWorkout()
                }
            }) {
                Image(systemName: "plus")
            }
        }
    }
}
