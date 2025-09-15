//
//  WorkoutCellView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI
import HealthKit
import Entities
import UseCases

struct HKWorkoutCellView: View {
    let workout: HKWorkout
    let isSelected: Bool
    let isSaved: Bool
    let action: () -> Void
    private let getHKWorkoutTypeInfoUseCase: UseCase.GetHKWorkoutTypeInfo = .init()

    var body: some View {
        let workoutInfo = getHKWorkoutTypeInfoUseCase.call(for: workout.workoutActivityType)
        Button(action: action) {
            HStack {
                Image(systemName: workoutInfo.symbol)
                    .font(.title)
                    .foregroundColor(isSaved ? .gray : .accentColor)
                VStack(alignment: .leading) {
                    Text(workoutInfo.name)
                        .font(.headline)
                    Text(workout.endDate, style: .date)
                        .font(.subheadline)
                }
                .foregroundColor(isSaved ? .gray : .primary)
                Spacer()
                Text(distance(for: workout))
                    .font(.headline)
                    .foregroundColor(isSaved ? .gray : .primary)
                Image(systemName: isSelected ? "checkmark.circle.fill" : isSaved ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(isSaved ? .gray : .accentColor)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
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

