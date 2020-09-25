//
//  ValidatePhoneRequest.swift
//  GariHub
//
//  Created by Kevin Lagat on 25/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation

struct OTPResponse: Codable {
    let id, firstName, lastName, gender: JSONNull?
    let phoneNumber: String
    let isRegistered, otpSent: Bool
    let emailAddress, emailStatus, accountStatus, userType: JSONNull?
    let createdAt, updatedAt: JSONNull?
    let success: Bool
    let message: JSONNull?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
