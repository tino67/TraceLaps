//
//  WorkoutDetailView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI
import MapKit

struct WorkoutDetailView: View {
    @StateObject var viewModel: WorkoutDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack {
            MapView(locations: viewModel.workout.locations)
                .frame(height: 300)

            VStack(alignment: .leading, spacing: 10) {
                Text("Workout Details")
                    .font(.title)

                HStack {
                    Text("Date:")
                        .font(.headline)
                    Text(viewModel.workout.date, style: .date)
                        .font(.subheadline)
                }

                HStack {
                    Text("Duration:")
                        .font(.headline)
                    Text(Formatters.shared.format(duration: viewModel.workout.duration) ?? "N/A")
                        .font(.subheadline)
                }

                HStack {
                    Text("Distance:")
                        .font(.headline)
                    Text(Formatters.shared.format(distance: viewModel.workout.distance))
                        .font(.subheadline)
                }

                HStack {
                    Text("Calories:")
                        .font(.headline)
                    Text(String(format: "%.2f kcal", viewModel.workout.calories))
                        .font(.subheadline)
                }

                HStack {
                    Text("Average Pace:")
                        .font(.headline)
                    Text(Formatters.shared.format(duration: viewModel.workout.duration, distance: viewModel.workout.distance))
                        .font(.subheadline)
                }
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Workout Detail")
        .toolbar {
            Button(action: {
                showDeleteConfirmation = true
            }) {
                Image(systemName: "trash")
            }
        }
        .alert("Delete Workout", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteWorkout()
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this workout?")
        }
    }
}
