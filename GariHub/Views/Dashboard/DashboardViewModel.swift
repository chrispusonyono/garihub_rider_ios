//
//  DashboardViewModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/4/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

class DashboardViewModel: BaseAuthModel {
    let router: StrongRouter<OnboardingRoutes>

    init(client: GariHubClient, router: StrongRouter<OnboardingRoutes>) {
            self.router = router
            super.init(client: client)
        }
}