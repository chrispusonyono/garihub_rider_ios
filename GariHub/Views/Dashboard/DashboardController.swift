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
    
    let vehicles: [String] = [
        "TAXI",
        "TOWTRUCK",
        "TOURVANS",
        "AMBULANCE"
    ]
    
    let processes: [String] = [
        "Order Cab",
        "Order Truck",
        "Order Bus, Shuttle",
        "Order Ambulance"
    ]
    
    let images: [UIImage] = [
        UIImage(named: "Asset 2@4x")!,
        UIImage(named: "Asset 10@4x")!,
        UIImage(named: "Asset 9@4x")!,
        UIImage(named: "Asset 8@4x")!
    ]
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileIImage: UIImageView!
    @IBOutlet weak var orderType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: DashboardCell.className, bundle: nil), forCellWithReuseIdentifier: DashboardCell.className)
        setupViews()
    }
    
    func setupViews() {
        myView.layer.cornerRadius = 20
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        orderType.setTitleTextAttributes(titleTextAttributes, for: .normal)
        orderType.setTitleTextAttributes(titleTextAttributes, for: .selected)
        searchBar.layer.cornerRadius = 10
    }

}

extension DashboardController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardCell.className, for: indexPath) as! DashboardCell
        
        cell.layer.cornerRadius  = 20
        cell.vehicleType.text = self.vehicles[indexPath.row]
        cell.processName.text = self.processes[indexPath.row]
        cell.dashImage.image = self.images[indexPath.item]
        
        return cell
    }
    
    
}

extension DashboardController: UICollectionViewDelegate {
    
}


extension DashboardController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 15) / 2, height: (collectionView.bounds.height - 15) / 2)
    }
}
