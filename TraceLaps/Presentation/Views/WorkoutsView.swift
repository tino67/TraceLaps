//
//  WorkoutsView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI

struct WorkoutsView: View {
    @StateObject var viewModel: WorkoutsViewModel
    @State private var showHealthKitAlert = false
    @State private var showImportWorkouts = false
    let coordinator: MainCoordinator

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            Group {
                if viewModel.workouts.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No workouts", systemImage: "figure.run.circle")
                    }, description: {
                        Text("Import workouts from HealthKit to get started.")
                    }, actions: {
                        Button(action: {
                            showImportWorkouts = true
                        }) {
                            Text("Import")
                        }
                    })
                } else {
                    List(viewModel.workouts) { workout in
                        Button(action: {
                            viewModel.workoutTapped(workout: workout)
                        }) {
                            WorkoutCellView(workout: workout)
                        }
                    }
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
                    showImportWorkouts = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showImportWorkouts) {
                ImportWorkoutsView(viewModel: viewModel)
            }
            .onChange(of: viewModel.isHealthKitAuthorized) { oldValue, newValue in
                if !newValue {
                    showHealthKitAlert = true
                }
            }
            .alert("HealthKit Access Denied", isPresented: $showHealthKitAlert) {
                Button("OK") {}
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text("Please grant access to HealthKit in the Settings app to import workouts.")
            }
            .navigationDestination(for: MainCoordinator.Destination.self) { destination in
                coordinator.view(for: destination)
            }
        }
    }
}
