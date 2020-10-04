//
//  EmailRegViewModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/2/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator

class EmailRegViewModel: BaseAuthModel {
    
    let router: StrongRouter<OnboardingRoutes>
    let phoneNumber: String
    let fullName: String
    let gender: String
    

    init(client: GariHubClient, router: StrongRouter<OnboardingRoutes>, phoneNumber:String, fullName: String, gender: String) {
        self.fullName = fullName
        self.gender = gender
        self.phoneNumber = phoneNumber
        self.router = router
        super.init(client: client)
    }
    
}
