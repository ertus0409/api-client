//
//  FoodTruckCell.swift
//  api-client
//
//  Created by Guner Babursah on 27/03/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import UIKit

class FoodTruckCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var foodtypeLbl: UILabel!
    @IBOutlet weak var avgcostLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(truck: FoodTruck) {
        nameLbl.text = truck.name
        foodtypeLbl.text = truck.foodtype
        avgcostLbl.text = "$\(truck.avgCost)"
    
    }



}
