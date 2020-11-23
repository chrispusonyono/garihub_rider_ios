//
//  SelectVehicleCell.swift
//  GariHub
//
//  Created by Kevin Lagat on 11/16/20.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit

class SelectVehicleCell: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var vehicleTier: UILabel!
    @IBOutlet weak var selectTime: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
