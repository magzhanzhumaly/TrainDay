//
//  CalendarGridView.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import SwiftUI

struct CalendarGridView: View {
    let cells: [CalendarDayCellModel]
    let onTap: (Date) -> Void

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(cells) { cell in
                CalendarDayCellView(cell: cell)
                    .onTapGesture {
                        if let date = cell.date {
                            onTap(date)
                        }
                    }
            }
        }
    }
}
