//
//  LoginRequest.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/1/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let emailAddress, password: String
}

struct LoginResponse: Codable {
    let id: Int
    let firstName, lastName, gender, phoneNumber: String
    let isRegistered, otpSent: Bool
    let emailAddress, emailStatus, accountStatus, userType: String
    let createdAt, updatedAt: String
    let success: Bool
    let message: JSONNull?
}

