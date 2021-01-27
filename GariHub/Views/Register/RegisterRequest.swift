//
//  RegisterRequest.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/2/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation

struct RegisterRequest: Codable {
    let firstName, lastName, gender, phoneNumber: String
    let emailAddress, userType, password: String
}

struct RegisterResponse: Codable {
    let identifier: String
}
