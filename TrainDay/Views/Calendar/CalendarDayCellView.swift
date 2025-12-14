//
//  CalendarDayCellView.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import SwiftUI

struct CalendarDayCellView: View {
    let cell: CalendarDayCellModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundFill)

            if cell.isToday {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary.opacity(0.35), lineWidth: 1.2)
            }

            VStack(spacing: 6) {
                Text(cell.dayNumber)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(foregroundStyle)
                    .frame(maxWidth: .infinity)

                markersView
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 6)
        }
        .frame(height: 52)
        .opacity(cell.date == nil ? 0.0 : 1.0)
    }

    private var backgroundFill: Color {
        if cell.isSelected {
            return Color.primary.opacity(0.12)
        }
        return Color.clear
    }

    private var foregroundStyle: Color {
        if cell.isSelected {
            return .primary
        }
        return .primary
    }

    @ViewBuilder
    private var markersView: some View {
        if cell.markers.isEmpty {
            Color.clear.frame(height: 6)
        } else {
            HStack(spacing: 4) {
                ForEach(cell.markers.prefix(3), id: \.self) { t in
                    Circle()
                        .fill(t.tint)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}
