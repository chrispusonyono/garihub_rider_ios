//
//  SelectVehicleController.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/16/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class SelectVehicleController: UIViewController {
    
    let vehicleTier: [String] = [
        "GariHub Go",
        "GariHub Boda"
    ]
    
    let time: [String] = [
        "7:30 pm",
        "7:30 pm"
    ]
    
    let price: [String] = [
        "KES 230.00",
        "KES 180.00"
    ]
    
    let images: [UIImage] = [
        UIImage(named: "Asset 2@4x")!,
        UIImage(named: "Asset 5@4x")!
    ]
    
    var delegate: ModalControllerDelegate?
    var bookRideDelegate: BookRideDelegate?
    var viewModel: SelectVehicleViewModel?
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentCashView: UIView!
    @IBOutlet weak var paymentMpesaView: UIView!
    @IBOutlet weak var confirmRideBtn: UIButton!
    @IBOutlet weak var selectDropDownImage: UIImageView!
    
    @IBOutlet weak var mpesaCheck: UIImageView!
    
    @IBOutlet weak var cashCheck: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SelectVehicleCell.className, bundle: nil), forCellReuseIdentifier: SelectVehicleCell.className)
        confirmRideBtn.addTarget(self, action: #selector(self.moveToNext(_:)), for: .touchUpInside)
        confirmRideBtn.layer.cornerRadius = 5
        self.view.layer.cornerRadius = 20
        setupViews()
        
    }
    
    @objc func moveToNext(_ sender: UIButton) {
        self.bookRideDelegate?.bookRideRequest()
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Success", message: "Your driver has been found. Click OK to proceed.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.dismiss(animated: true, completion: {
                    let driverLocation = DriverLocationController()
                    self.delegate?.parentController.navigationController?.pushViewController(driverLocation, animated: true)
                })
            })
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    func setupViews(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.selectPaymentMethod(_:)))
        paymentCashView.isUserInteractionEnabled = true
        paymentCashView.addGestureRecognizer(tap)
        paymentMpesaView.isUserInteractionEnabled = true
        paymentMpesaView.addGestureRecognizer(tap)
    }
    
    @objc func selectPaymentMethod(_ sender: UITapGestureRecognizer) {
        
        
        cashCheck.isHidden = false
        paymentCashView.layer.backgroundColor = UIColor.gray.cgColor
        
    }
    
}


extension SelectVehicleController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

extension SelectVehicleController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectVehicleCell.className, for: indexPath) as! SelectVehicleCell
        
        cell.carImage.image = self.images[indexPath.row]
        cell.price.text = self.price[indexPath.row]
        cell.selectTime.text = self.time[indexPath.row]
        cell.vehicleTier.text = self.vehicleTier[indexPath.row]
        return cell
    }
    
    
}
