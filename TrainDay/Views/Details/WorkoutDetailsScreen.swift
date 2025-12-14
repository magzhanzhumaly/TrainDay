//
//  WorkoutDetailsScreen.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import SwiftUI

struct WorkoutDetailsScreen: View {
    @StateObject var viewModel: WorkoutDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                header

                WorkoutStatsCard(
                    distance: viewModel.distanceText,
                    duration: viewModel.durationText
                )

                if let comment = viewModel.commentText {
                    CommentCard(text: comment)
                }

                if !viewModel.diagramPoints.isEmpty {
                    HeartRateChartView(points: viewModel.diagramPoints)
                } else {
                    EmptyChartCard()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            await viewModel.load()
        }
        .overlay(alignment: .bottom) {
            if let error = viewModel.errorText {
                ErrorToast(text: error)
                    .padding(.bottom, 12)
            }
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(viewModel.tint.opacity(0.18))
                    .frame(width: 52, height: 52)

                Image(systemName: viewModel.symbolName)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(viewModel.tint)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title)
                    .font(.title3.weight(.semibold))

                Text(viewModel.dateTimeText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.primary.opacity(0.06))
        )
    }
}
