//
//  ReviewCell.swift
//  api-client
//
//  Created by Guner Babursah on 04/06/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    //IBOUTLETS:
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var reviewTextLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(review: FoodTruckReview) {
        
        titleLbl.text = review.title
        reviewTextLbl.text = review.text
        
    }
    

}
