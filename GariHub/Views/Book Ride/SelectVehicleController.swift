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
    
    var driverInfo: BookRideResponse?
    
    var delegate: ModalControllerDelegate?
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
//        self.bookRideDelegate?.bookRideRequest()
        self.showSpinner(onView: self.view)
        let userLoc = UserDefaults.standard.dictionary(forKey: "currentLocation")
        let destination = UserDefaults.standard.dictionary(forKey: "destinationLocation")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let latitude = userLoc?["lat"]
        let latNum = formatter.number(from: latitude as! String)
        
        let longitude = userLoc?["long"]
        let longNum = formatter.number(from: longitude as! String)
        let lat = destination?["lat"]
        let latitudeNum = formatter.number(from: lat as! String)
        let long = destination?["long"]
        let longitudeNum = formatter.number(from: long as! String)
        
        guard let pickupLat = latNum else { return }
        guard let pickupLong = longNum else { return }
        guard let dropOffLat = latitudeNum else { return }
        guard let dropOffLong = longitudeNum else { return }
        
        let semaphore = DispatchSemaphore (value: 0)
        
        let parameters = "{\n\t\"userId\": \"{% response 'body', 'req_ad54022f8889498fae09d55a8f7e43d2', 'b64::JC5pZGVudGlmaWVy::46b', 'never', 60 %}\",\n\t\"pickupLat\": \"\(String(describing: pickupLat))\",\n\t\"pickupLon\": \"\(String(describing: pickupLong))\",\n\t\"dropOffLat\": \"\(String(describing: dropOffLat))\",\n\t\"dropOffLon\": \"\(String(describing: dropOffLong))\",\n\t\"fcmToken\": \"eRu0GrEOpk0juP0Mo6wlJj:APA91bFoaaW80HMkiEEsXTGG1fHxb5txsmxi364wgsfaIPwf9rGZQV6rDFNxLdY0tsDm6QlCt5YIvpEnO3pxdhOu5WfPxTE3Kfvi2w7qcPKtK33LHrWsITECq4aFhR5A61cZhCgCP7zG\",\n\t\"vehicleType\": \"TAXI\",\n\t\"paymentMode\": \"CASH\"\n}"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "http://dev.garihub.com/api/trip-service/v1/trip/book-ride")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.removeSpinner()
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            do {
                let bookRideResponse = try JSONDecoder().decode(BookRideResponse.self, from: data)
                print(bookRideResponse)
                self.driverInfo = bookRideResponse
                
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Success", message: "Your driver has been found. Click OK to proceed.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        self.dismiss(animated: true, completion: {

                            let driverLocation = DriverLocationController()
                            driverLocation.driverInfo = self.driverInfo
                            self.delegate?.parentController.navigationController?.pushViewController(driverLocation, animated: true)
                        })
                    })

                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)

                }
                
            }
            catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "No vehicles nearby", message: "Failed to fetch vehicles nearby, Please try again later.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: "Failed to fetch vehicle, Please try again later.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
    }
    
    func setupViews(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.selectPaymentMethod(_:)))
        let tapMpesa = UITapGestureRecognizer(target: self, action: #selector(self.selectMpesa(_:)))
        
        paymentCashView.isUserInteractionEnabled = true
        paymentCashView.addGestureRecognizer(tap)
        paymentMpesaView.isUserInteractionEnabled = true
        paymentMpesaView.addGestureRecognizer(tapMpesa)
    }
    
    @objc func selectPaymentMethod(_ sender: UITapGestureRecognizer) {
        
        if self.cashCheck.isHidden {
            self.cashCheck.isHidden = false
            self.paymentCashView.layer.backgroundColor = UIColor.lightGray.cgColor
        }
//        else {
//            self.cashCheck.isHidden = true
//            self.paymentCashView.layer.backgroundColor = UIColor.white.cgColor
//        }
//        self.cashCheck.isHidden = !self.cashCheck.isHidden
        
        
        
    }
    
    @objc func selectMpesa(_ sender: UITapGestureRecognizer) {
        if self.mpesaCheck.isHidden {
            self.mpesaCheck.isHidden = false
            self.paymentMpesaView.layer.backgroundColor = UIColor.lightGray.cgColor
        }
//        else {
//            self.mpesaCheck.isHidden = true
//            self.paymentMpesaView.layer.backgroundColor = UIColor.white.cgColor
//        }
//        self.mpesaCheck.isHidden = !self.mpesaCheck.isHidden
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
