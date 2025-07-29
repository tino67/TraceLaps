//
//  ContentView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let localDataSource = WorkoutLocalDataSourceImpl()
        let repository = WorkoutRepositoryImpl(localDataSource: localDataSource)
        let getWorkoutsUseCase = GetWorkouts(workoutRepository: repository)
        let saveWorkoutUseCase = SaveWorkout(workoutRepository: repository)
        let viewModel = WorkoutsViewModel(getWorkoutsUseCase: getWorkoutsUseCase, saveWorkoutUseCase: saveWorkoutUseCase)

        NavigationView {
            WorkoutsView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
