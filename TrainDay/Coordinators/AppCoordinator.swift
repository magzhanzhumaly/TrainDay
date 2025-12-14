//
//  AppCoordinator.swift
//  WorkoutCalendar
//
//  Created by Magzhan Zhumaly on 14.12.2025.
//

import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    private let services: AppServices

    init(services: AppServices = .live()) {
        self.services = services
    }

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    // MARK: - Screen factory

    func makeRoot() -> some View {
        let vm = CalendarViewModel(api: services.api)
        return CalendarScreen(viewModel: vm)
    }
    
    func makeDestination(for route: Route) -> some View {
        switch route {
        case .workoutDetails(let workoutId):
            let vm = WorkoutDetailsViewModel(api: services.api, workoutId: workoutId)
            return WorkoutDetailsScreen(viewModel: vm)
        }
    }}
