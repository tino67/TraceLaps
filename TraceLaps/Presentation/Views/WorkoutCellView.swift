//
//  WorkoutCellView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI

struct WorkoutCellView: View {
    let workout: Workout

    var body: some View {
        HStack {
            Image(systemName: "figure.run")
                .font(.title)
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                Text("Running")
                    .font(.headline)
                Text(workout.date, style: .date)
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(distance(for: workout))
                    .font(.headline)
                Text(Formatters.shared.format(duration: workout.duration) ?? "N/A")
                    .font(.subheadline)
            }
        }
    }

    private func distance(for workout: Workout) -> String {
        return Formatters.shared.format(distance: workout.distance)
    }
}
