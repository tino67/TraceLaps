//
//  WorkoutCellView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI
import HealthKit

struct WorkoutCellView: View {
    let workout: HKWorkout
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        HStack {
            Image(systemName: workout.workoutActivityType.symbol)
                .font(.title)
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                Text(workout.workoutActivityType.name)
                    .font(.headline)
                Text(workout.endDate, style: .date)
                    .font(.subheadline)
            }
            Spacer()
            Text(distance(for: workout))
                .font(.headline)
            Button(action: action) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }

    private func distance(for workout: HKWorkout) -> String {
        let distance = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
        let measurement = Measurement(value: distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter.maximumFractionDigits = 2
        return formatter.string(from: measurement)
    }
}

extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .running:
            return "Running"
        case .walking:
            return "Walking"
        case .cycling:
            return "Cycling"
        default:
            return "Workout"
        }
    }

    var symbol: String {
        switch self {
        case .running:
            return "figure.run"
        case .walking:
            return "figure.walk"
        case .cycling:
            return "figure.bike"
        default:
            return "figure.walk"
        }
    }
}
