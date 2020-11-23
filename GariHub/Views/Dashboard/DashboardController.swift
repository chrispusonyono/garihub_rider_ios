//
//  DashboardController.swift
//  GariHub
//
//  Created by Kevin Lagat on 10/4/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class DashboardController: BaseTextFieldController {
    
    var viewModel: DashboardViewModel?
    
    
    let images: [UIImage] = [
        UIImage(named: "Group 3")!,
        UIImage(named: "Group 3 Copy")!,
        UIImage(named: "Group 5")!,
        UIImage(named: "Group 6")!
    ]
    
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: DashboardCell.className, bundle: nil), forCellWithReuseIdentifier: DashboardCell.className)
        setupViews()
        collectionView.reloadData()
    }
    
    func setupViews() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        orderType.setTitleTextAttributes(titleTextAttributes, for: .normal)
        orderType.setTitleTextAttributes(titleTextAttributes, for: .selected)
//        searchBar.layer.cornerRadius = 10
        
        guard let vm = self.viewModel else { return }
        guard vm.client.isLoggedIn else {
            return
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setAppNavigationBar()
        self.navigationItem.leftBarButtonItem = self.navigationItemFactory(action: #selector(self.mainMenuTapped(_:)), image: UIImage(named: "menu_icon"))
        self.navigationItem.title = "Dashboard"

    }
    
    private func navigationItemFactory(action: Selector, image: UIImage?) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.imageView?.contentMode = .center
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        return UIBarButtonItem(customView: button)
    }
    
    @objc private func mainMenuTapped(_ sender: UIBarButtonItem) {

        guard let vm = self.viewModel else { return }
        vm.router.trigger(.side)
    }

}

extension DashboardController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardCell.className, for: indexPath) as! DashboardCell
        
        cell.layer.cornerRadius  = 20
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = false
        cell.moduleIcon.image = self.images[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
}

extension DashboardController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vm = self.viewModel else { return }
        
        if indexPath.item == 0 {
            vm.router.trigger(.maps)
        }
    }
    
}

extension DashboardController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 20) / 2, height: (collectionView.bounds.height) / 2)
    }
}
