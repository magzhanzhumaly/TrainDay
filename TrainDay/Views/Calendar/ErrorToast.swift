//
//  ErrorToast.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//


import SwiftUI

struct ErrorToast: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.black.opacity(0.85))
            )
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 16)
    }
}