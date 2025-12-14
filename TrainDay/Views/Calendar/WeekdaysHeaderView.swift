//
//  WeekdaysHeaderView.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//


import SwiftUI

struct WeekdaysHeaderView: View {
    private let labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(labels, id: \.self) { t in
                Text(t)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 2)
    }
}