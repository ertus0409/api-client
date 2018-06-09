//
//  FoodTruckReview.swift
//  api-client
//
//  Created by Guner Babursah on 27/02/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import Foundation

struct FoodTruckReview {
    var id: String = ""
    var title: String = ""
    var text: String = ""
    
    static func parseReviewJsonData(data: Data) -> [FoodTruckReview] {
        
        var foodTruckReviews = [FoodTruckReview]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let reviews = jsonResult as? [Dictionary<String, AnyObject>]{
                for review in reviews {
                    var newReview = FoodTruckReview()
                    newReview.id = review["_id"] as! String
                    newReview.text = review["text"] as! String
                    newReview.title = review["title"] as! String
                    
                    foodTruckReviews.append(newReview)
                }
                
            }
        } catch let err {
            print(err)
        }
        return foodTruckReviews
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
