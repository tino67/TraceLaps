//
//  WorkoutDetailView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI
import MapKit

struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        VStack {
            MapView(locations: workout.locations)
                .frame(height: 300)

            VStack(alignment: .leading, spacing: 10) {
                Text("Workout Details")
                    .font(.title)

                HStack {
                    Text("Date:")
                        .font(.headline)
                    Text(workout.date, style: .date)
                        .font(.subheadline)
                }

                HStack {
                    Text("Duration:")
                        .font(.headline)
                    Text(String(format: "%.2f", workout.duration / 60))
                        .font(.subheadline)
                }

                HStack {
                    Text("Distance:")
                        .font(.headline)
                    Text(String(format: "%.2f km", workout.distance / 1000))
                        .font(.subheadline)
                }

                HStack {
                    Text("Calories:")
                        .font(.headline)
                    Text(String(format: "%.2f kcal", workout.calories))
                        .font(.subheadline)
                }

                HStack {
                    Text("Average Pace:")
                        .font(.headline)
                    Text(String(format: "%.2f min/km", (workout.duration / 60) / (workout.distance / 1000)))
                        .font(.subheadline)
                }
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Workout Detail")
    }
}
