//
//  WorkoutRowView.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import SwiftUI

struct WorkoutRowView: View {
    let workout: WorkoutListItem

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(workout.workoutActivityType.tint.opacity(0.18))
                    .frame(width: 36, height: 36)

                Image(systemName: workout.workoutActivityType.sfSymbolName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(workout.workoutActivityType.tint)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(workout.workoutActivityType.title)
                    .font(.subheadline.weight(.semibold))

                Text(timeString(from: workout.workoutStartDate))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.primary.opacity(0.06))
        )
    }

    private func timeString(from date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale.current
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}
