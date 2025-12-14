//
//  WorkoutStatsCard.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import SwiftUI

struct WorkoutStatsCard: View {
    let distance: String
    let duration: String

    var body: some View {
        HStack(spacing: 12) {
            stat(title: "Distance", value: distance, symbol: "map")
            stat(title: "Duration", value: duration, symbol: "timer")
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.primary.opacity(0.06))
        )
    }

    private func stat(title: String, value: String, symbol: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: symbol)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.subheadline.weight(.semibold))
            }

            Spacer(minLength: 0)
        }
    }
}
