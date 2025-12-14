//
//  AppRootView.swift
//  TrainDay
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//


import SwiftUI

struct AppRootView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeRoot()
                .navigationDestination(for: Route.self) { route in
                    coordinator.makeDestination(for: route)
                }
        }
        .environmentObject(coordinator)
    }
}