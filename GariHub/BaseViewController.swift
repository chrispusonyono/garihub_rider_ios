//
//  BaseViewController.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/6/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var modalController: UIViewController?
    
    func presentModalController(viewController: UIViewController, presentationStyle: UIModalPresentationStyle = .custom) {
        
        let modalTransitioningDelegate = ModalTransitioningDelegate(viewController: viewController, presentingViewController: self)
        
        viewController.transitioningDelegate = modalTransitioningDelegate
        viewController.modalPresentationStyle = presentationStyle
        self.present(viewController, animated: true)
        
        modalController = viewController
    }

}
