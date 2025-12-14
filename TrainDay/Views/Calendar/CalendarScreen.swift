//
//  CalendarScreen.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import SwiftUI

struct CalendarScreen: View {
    @StateObject var viewModel: CalendarViewModel
    @EnvironmentObject private var coordinator: AppCoordinator

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    var body: some View {
        VStack(spacing: 12) {
            MonthHeaderView(
                title: viewModel.monthTitle,
                onPrev: { viewModel.goToPrevMonth() },
                onNext: { viewModel.goToNextMonth() }
            )

            WeekdaysHeaderView()

            CalendarGridView(
                cells: viewModel.gridCells,
                onTap: { date in
                    viewModel.select(date: date)
                }
            )

            Divider()
                .opacity(0.6)

            WorkoutsListView(
                workouts: viewModel.selectedDayWorkouts,
                onTapWorkout: { workout in
                    coordinator.push(.workoutDetails(workoutId: workout.workoutKey))
                }
            )

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .navigationTitle("TrainDay")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .overlay(alignment: .bottom) {
            if let error = viewModel.errorText {
                ErrorToast(text: error)
                    .padding(.bottom, 12)
            }
        }
        .task {
            await viewModel.load()
        }
    }
}
