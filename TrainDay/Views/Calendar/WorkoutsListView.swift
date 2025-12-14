//
//  WorkoutsListView.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//


import SwiftUI

struct WorkoutsListView: View {
    let workouts: [WorkoutListItem]
    let onTapWorkout: (WorkoutListItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Workouts")
                .font(.headline)

            if workouts.isEmpty {
                Text("No workouts for selected day")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
            } else {
                VStack(spacing: 10) {
                    ForEach(workouts) { w in
                        WorkoutRowView(workout: w)
                            .onTapGesture { onTapWorkout(w) }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}