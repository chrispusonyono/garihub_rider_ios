//
//  LoginViewModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/6/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

class LoginViewModel: BaseAuthModel {
    let router: StrongRouter<OnboardingRoutes>
    
    init(client: GariHubClient, router: StrongRouter<OnboardingRoutes>) {
        self.router = router
        super.init(client: client)
    }
}
 
