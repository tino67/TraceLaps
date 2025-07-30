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
    @State private var showDeleteConfirmation = false
    @State private var workoutToDelete: Workout?
    @AppStorage("lastDeleted") private var lastDeleted: TimeInterval = 0.0
    let coordinator: MainCoordinator

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            List {
                ForEach(viewModel.workouts) { workout in
                    DeletableRow {
                        Button(action: {
                            viewModel.workoutTapped(workout: workout)
                        }) {
                            WorkoutCellView(workout: workout)
                        }
                    } onDelete: {
                        if Date().timeIntervalSince(Date(timeIntervalSince1970: lastDeleted)) < 120 {
                            viewModel.delete(workout: workout)
                        } else {
                            workoutToDelete = workout
                            showDeleteConfirmation = true
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
            .alert("Delete Workout", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let workout = workoutToDelete {
                        viewModel.delete(workout: workout)
                        lastDeleted = Date().timeIntervalSince1970
                    }
                }
            } message: {
                Text("Are you sure you want to delete this workout?")
            }
        }
    }
}
