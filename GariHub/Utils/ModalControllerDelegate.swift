//
//  ModalControllerDelegate.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/6/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import Foundation
import UIKit

protocol ModalControllerDelegate: class {
    func removeModalController(controller: UIViewController)
    var parentController: UIViewController { get }
}

protocol CallDriverDelegate {
    func callDriver()
    func cancelRide()
}
