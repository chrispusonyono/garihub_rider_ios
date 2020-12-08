//
//  OTPRequest.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/2/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct OTPRequest: Codable {
    let phoneNumber, otpCode: String
}


struct RegOTPResponse: Codable {
    let otpValid: Bool
    let message: String
    let otpUsed: Bool
}
