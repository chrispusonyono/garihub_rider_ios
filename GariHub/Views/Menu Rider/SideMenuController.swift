//
//  SideMenuController.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/25/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class SideMenuController: UIViewController {
    
    var viewModel: SideMenuViewModel?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userRating: UILabel!
    @IBOutlet weak var waitingTime: UILabel!
    @IBOutlet weak var riderEmail: UILabel!
    @IBOutlet weak var riderNumber: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    @objc func didSwipe(_ recognizer: UIPanGestureRecognizer){
        
        guard recognizer.view != nil else { return }
        
        if recognizer.state == .ended {
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
                recognizer.view!.center.x += 100
                recognizer.view?.center.y += 100
            })
            animator.startAnimation()
        }

    }


}
