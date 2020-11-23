//
//  BookRideRequest.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/17/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
struct BookRideRequest: Codable {
    let userID, pickupLat, pickupLon, dropOffLat: String
    let dropOffLon, fcmToken, vehicleType, paymentMode: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case pickupLat, pickupLon, dropOffLat, dropOffLon, fcmToken, vehicleType, paymentMode
    }
}


struct BookRideResponse: Codable {
    let to, from, requestType: String
    let vehicle: Vehicle
    let driver: Driver
    let trip: Trip
}

// MARK: - Driver
struct Driver: Codable {
    let firstName, lastName, gender, phoneNumber: String
    let emailAddress, emailStatus, accountStatus: String
    let onDuty: Bool
    let identifier: String
    let rating: Int
    let fcmToken: String
}

// MARK: - Trip
struct Trip: Codable {
    let id: Int
    let driverID, riderID: String
    let vehicleID: Int
    let licensePlate, pickupLat, pickupLon, pickupAddress: String
    let dropOffLat, dropOffLon, dropOffAddress: String
    let tripDistance: Double
    let tripDuration: Int
    let currency, paymentMode: String
    let tripCost: Int
    let tripStatus, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case driverID = "driverId"
        case riderID = "riderId"
        case vehicleID = "vehicleId"
        case licensePlate, pickupLat, pickupLon, pickupAddress, dropOffLat, dropOffLon, dropOffAddress, tripDistance, tripDuration, currency, paymentMode, tripCost, tripStatus, createdAt, updatedAt
    }
}

// MARK: - Vehicle
struct Vehicle: Codable {
    let id: Int
    let driverID, regNo, vehicleMake, vehicleModel: String
    let vehicleColor: String
    let vehicleCapacity: Int
    let vehicleType, vehicleLat, vehicleLon, vehicleBearing: String
    let onTrip: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case driverID = "driverId"
        case regNo, vehicleMake, vehicleModel, vehicleColor, vehicleCapacity, vehicleType, vehicleLat, vehicleLon, vehicleBearing, onTrip
    }
}
