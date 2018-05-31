//
//  FoodTruck.swift
//  api-client
//
//  Created by Guner Babursah on 27/02/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class FoodTruck: NSObject, MKAnnotation {
    var id: String = ""
    var name: String = ""
    var foodtype: String = ""
    var avgCost: Double = 0.0
    
    var geomType: String = "Point"
    
    var lat: Double = 0.0
    var long: Double = 0.0
    
    @objc var title: String?
    @objc var subtitle: String?
    
    @objc var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
    }
    
    static func ParseFoodTruckJsonData(data: Data) -> [FoodTruck] {
        var foodtrucks = [FoodTruck]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            // Parse JSON Data
            if let trucks = jsonResult as? [Dictionary<String, AnyObject>] {
                for truck in trucks {
                    let newTruck = FoodTruck()
                    newTruck.id = truck["_id"] as! String
                    newTruck.foodtype = truck["foodtype"] as! String
                    newTruck.avgCost = truck["avgcost"] as! Double
                    newTruck.name = truck["name"] as! String
                    let geometry = truck["geometry"] as! Dictionary<String, AnyObject>
                    newTruck.geomType = geometry["type"] as! String
                    let coords = geometry["coordinates"] as! NSArray
                    newTruck.lat = coords[0] as! Double
                    newTruck.long = coords[1] as! Double
                    newTruck.title = newTruck.name
                    newTruck.subtitle = newTruck.foodtype
//                    print("MyTruck: ",newTruck.title, newTruck.subtitle)
                    foodtrucks.append(newTruck)
                }
            }
        } catch let err {
            print(err)
        }
        
        return foodtrucks
    }
    
    
}
