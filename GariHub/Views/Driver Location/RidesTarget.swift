//
//  RidesTarget.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/18/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import Moya

enum RidesTarget {
    case bookRide(request: BookRideRequest)

}

extension RidesTarget: TargetType {
    var baseURL: URL {
        return URL (string: "http://dev.garihub.com/api/trip-service/")!
    }
    
    var path: String {
        switch self {
        case .bookRide:
            return "v1/trip/book-ride"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .bookRide:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .bookRide(let request):
            return [
                "userId": request.userID,
                "pickupLat": request.pickupLat,
                "pickupLong": request.pickupLon,
                "dropOffLat": request.dropOffLat,
                "dropOffLong": request.dropOffLon,
                "fcmToken": request.fcmToken,
                "vehicleType": request.vehicleType,
                "paymentMode": request.paymentMode
            ]
        }
    }
    
    var task: Task {
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters,
                                      encoding: JSONEncoding.default)
        }
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
        ]
    }
    
    
}
