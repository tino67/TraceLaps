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
            Text(distance(for: workout))
                .font(.headline)
        }
    }

    private func distance(for workout: Workout) -> String {
        let distance = workout.distance
        let measurement = Measurement(value: distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter.maximumFractionDigits = 2
        return formatter.string(from: measurement)
    }
}
