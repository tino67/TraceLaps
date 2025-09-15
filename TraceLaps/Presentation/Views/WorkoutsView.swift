//
//  WorkoutsView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI

struct WorkoutsView: View {
    @StateObject private var viewModel: WorkoutsViewModel
    @State private var showImportWorkouts = false
    private let coordinator: MainCoordinator

    init(viewModel: WorkoutsViewModel, coordinator: MainCoordinator) {
        self.coordinator = coordinator
        self._viewModel = .init(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            contentView
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
                    ImportWorkoutsView()
                }
                .navigationDestination(for: MainCoordinator.Destination.self) { destination in
                    coordinator.view(for: destination)
                }
        }
    }

    @ViewBuilder
    var contentView: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .error(let error):
            ContentUnavailableView("Error", image: "exclamationmark.triangle", description: Text(error.localizedDescription))
        case .data(let workouts):
            if workouts.isEmpty {
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
                List(workouts) { workout in
                    WorkoutCellView(workout: workout)
                        .onTapGesture {
                            viewModel.workoutTapped(workout: workout)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.delete(workout: workout)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }

            }
        }
    }
}
