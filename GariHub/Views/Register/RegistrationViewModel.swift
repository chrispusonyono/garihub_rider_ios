//
//  RegistrationViewModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 25/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

class RegistrationViewModel: BaseAuthModel {
    
    let router: StrongRouter<OnboardingRoutes>

    init(client: GariHubClient, router: StrongRouter<OnboardingRoutes>) {
        self.router = router
        super.init(client: client)
    }
    
}
