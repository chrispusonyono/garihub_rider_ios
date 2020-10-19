//
//  Destination.swift
//  GariHub
//
//  Created by Chrispus Onyono on 05/10/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class Destination: UIViewController {

    @IBOutlet weak var recentDestinationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialize()
    }
    private func initialize(){
        initializeHideKeyboard()
        recentDestinationView.layer.cornerRadius = 20
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
