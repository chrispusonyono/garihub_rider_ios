//
//  RegTwoViewModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/2/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

class RegTwoViewModel: BaseAuthModel {
    let router: StrongRouter<OnboardingRoutes>
    let phoneNumber: String

    init(client: GariHubClient, router: StrongRouter<OnboardingRoutes>, phoneNumber: String) {
        self.router = router
        self.phoneNumber = phoneNumber
        super.init(client: client)
       }
}
