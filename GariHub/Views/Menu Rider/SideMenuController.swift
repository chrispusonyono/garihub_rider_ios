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
    
    let titles: [String] = [
        "Profile Management",
        "Trip and Ride History",
        "Payment History",
        "Settings",
        "Promo & Coupons",
        "Summary",
        "Help & Support",
        "Inviting Friends",
        "Logout"
    ]
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userRating: UILabel!
    @IBOutlet weak var waitingTime: UILabel!
    @IBOutlet weak var riderEmail: UILabel!
    @IBOutlet weak var riderNumber: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var riderName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.register(UINib(nibName: SideMenuCell.className, bundle: nil), forCellReuseIdentifier: SideMenuCell.className)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didSwipe(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    
    @objc func didSwipe(_ recognizer: UIPanGestureRecognizer){
        
        let location = recognizer.location(in: self.view).x
        let isDraggingFromRightToLeft = location > 25
        
        
        switch recognizer.state {
        case .ended:
            if isDraggingFromRightToLeft {
                self.viewModel?.router.trigger(.pop)
            }
        default:
            break
        }

    }


}


extension SideMenuController: UITableViewDelegate {
    
    
    
    
    
}

extension SideMenuController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.className) as! SideMenuCell
        cell.menuType.text = titles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    
}
