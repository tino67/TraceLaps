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

    var body: some View {
        List(viewModel.workouts) { workout in
            VStack(alignment: .leading) {
                Text("Duration: \(workout.duration)")
                    .font(.headline)
                Text("Distance: \(workout.distance)")
                    .font(.subheadline)
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
                Task {
                    await viewModel.addWorkout()
                }
            }) {
                Image(systemName: "plus")
            }
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
    }
}
