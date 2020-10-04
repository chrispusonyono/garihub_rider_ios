//
//  OTPViewModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/2/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

class OTPViewModel: BaseAuthModel  {
    let phoneNumber: String
    
    let router: StrongRouter<OnboardingRoutes>

    
    init(client: GariHubClient, phoneNumber: String, router: StrongRouter<OnboardingRoutes>) {
        self.phoneNumber = phoneNumber
        self.router = router
        super.init(client: client)
    }
}
