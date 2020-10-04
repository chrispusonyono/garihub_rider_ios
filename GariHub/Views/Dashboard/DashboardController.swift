//
//  DashboardController.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/4/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class DashboardController: UIViewController {
    
    var viewModel: DashboardViewModel?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileIImage: UIImageView!
    @IBOutlet weak var orderType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
