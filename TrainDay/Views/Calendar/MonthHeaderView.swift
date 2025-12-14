//
//  MonthHeaderView.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import SwiftUI

struct MonthHeaderView: View {
    let title: String
    let onPrev: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onPrev) {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .frame(width: 40, height: 40)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)

            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .frame(width: 40, height: 40)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
    }
}
