//
//  CommentCard.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//


import SwiftUI

struct CommentCard: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Comment")
                .font(.headline)

            Text(text)
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