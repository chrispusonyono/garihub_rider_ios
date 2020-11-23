//
//  SelectVehicleViewModel.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/18/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import XCoordinator



class SelectVehicleViewModel: BaseRideModel {
    let router: StrongRouter<OnboardingRoutes>

    var driverResponse: DriverDetailResponse
    
    init(client: GariHubClient, router: StrongRouter<OnboardingRoutes>, driverResponse: DriverDetailResponse) {
        self.router = router
        self.driverResponse = driverResponse
        super.init(client: client)
    }
}
