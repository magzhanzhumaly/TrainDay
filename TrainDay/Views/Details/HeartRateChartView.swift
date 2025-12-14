//
//  HeartRateChartView.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import SwiftUI
import Charts

struct HeartRateChartView: View {
    let points: [DiagramPoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Heart rate")
                .font(.headline)

            Chart(points, id: \.timeNumeric) { p in
                LineMark(
                    x: .value("Time", p.timeNumeric),
                    y: .value("HR", p.heartRate)
                )
            }
            .frame(height: 180)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.primary.opacity(0.06))
        )
    }
}
