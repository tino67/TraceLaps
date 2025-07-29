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
                    Text(Formatters.shared.format(duration: workout.duration) ?? "N/A")
                        .font(.subheadline)
                }

                HStack {
                    Text("Distance:")
                        .font(.headline)
                    Text(Formatters.shared.format(distance: workout.distance))
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
                    Text(Formatters.shared.format(duration: workout.duration, distance: workout.distance))
                        .font(.subheadline)
                }
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Workout Detail")
    }
}
