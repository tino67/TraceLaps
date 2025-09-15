//
//  WorkoutCellView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI
import Entities
import UseCases

struct WorkoutCellView: View {
    let workout: Workout
    private let getWorkoutTypeInfoUseCase: UseCase.GetWorkoutTypeInfo = .init()

    var body: some View {
        let workoutInfo = getWorkoutTypeInfoUseCase.call(for: workout.type)

        HStack {
            Image(systemName: workoutInfo.symbol)
                .font(.title)
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                Text(workoutInfo.name)
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
