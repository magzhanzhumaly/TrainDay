//
//  EmptyChartCard.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//


import SwiftUI

struct EmptyChartCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Heart rate")
                .font(.headline)

            Text("No diagram data for this workout")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.primary.opacity(0.06))
        )
    }
}