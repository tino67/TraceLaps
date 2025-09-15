//
//  ImportWorkoutsView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI
import HealthKit
import UseCases

extension HKWorkout: @retroactive Identifiable { }

struct ImportWorkoutsView: View {
    @StateObject var viewModel: ImportWorkoutsViewModel = .init(
        getWorkoutsUseCase: UseCase.GetWorkouts(),
        saveWorkoutUseCase: UseCase.SaveWorkout(),
        healthKitManager: HealthKitManager()
    )

    @Environment(\.dismiss) private var dismiss
    @State private var selectedWorkouts = Set<HKWorkout>()

    var body: some View {
        NavigationView {
            contentView
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

    @ViewBuilder
    var contentView: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .data(let healthKitWorkouts, let status):
            if status == .authorized || !healthKitWorkouts.isEmpty {
                List {
                    ForEach(healthKitWorkouts, id: \.workout.uuid) { (workout, isAlreadyImported) in
                        HKWorkoutCellView(workout: workout, isSelected: selectedWorkouts.contains(workout), isSaved: isAlreadyImported) {
                            if !isAlreadyImported {
                                if selectedWorkouts.contains(workout) {
                                    selectedWorkouts.remove(workout)
                                } else {
                                    selectedWorkouts.insert(workout)
                                }
                            }
                        }
                        .disabled(isAlreadyImported)
                    }
                }
            } else {
                ContentUnavailableView {
                    Image(systemName: "exclamationmark.triangle")
                } description: {
                    VStack {
                        Text("HealthKit Access Denied")
                            .font(.title3)
                        Text("Please grant access to HealthKit in the Settings app to import workouts.")
                            .font(.body)
                    }
                } actions: {
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
        case .error(let error):
            ContentUnavailableView("Error", image: "exclamationmark.triangle", description: Text(error.localizedDescription))
        }
    }
}
