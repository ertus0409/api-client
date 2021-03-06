//
//  DataService.swift
//  api-client
//
//  Created by Guner Babursah on 16/03/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import Foundation

protocol DataServiceDelegate: class {
    func trucksLoaded()
    func reviewsLoaded()
}

class DataService {
    
    static let instance = DataService()
    
    weak var delegate: DataServiceDelegate?
    var foodTrucks = [FoodTruck]()
    var reviews = [FoodTruckReview]()
    
    //GET ALL FOODTRUCKS
    func getAllFoodTrucks(){
        let sessionConfig = URLSessionConfiguration.default
        
        //Create session, or optionally set a URLSessionDelegate
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        //Create the request
        //Get all foodtrucks ( GET /api/v1/foodtruck )
        guard let URL = URL(string: GET_ALL_FT_URL) else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                //Success !
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL session task succeeded. HTTP \(statusCode)")
                if let data = data {
                    self.foodTrucks = FoodTruck.ParseFoodTruckJsonData(data: data)
                    self.delegate?.trucksLoaded()
                }
            }
            else {
                //Failure
                print("URL session task failed HTTP: \(error!.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    //Get all reviews for a specific foodtruck
    func getAllReviews(for truck: FoodTruck) {
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "\(GET_ALL_FT_REVIEWS)/\(truck.id)") else { return }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error == nil {
                //Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL SESSION successful \(statusCode)")
                //parse json data
                if let data = data {
                    self.reviews = FoodTruckReview.parseReviewJsonData(data: data)
                    self.delegate?.reviewsLoaded()
                }
            } else {
                //Failure
                print("Url session task failed: \(error?.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    //POST add a new foodtruck
    func addNewTruck(_ name: String, foodtype: String, avgcost: Double, latitude: Double, longitude: Double, completion: @escaping callback){
        
        //Construct JSON
        let json: [String: Any] = [
            "name": name,
            "foodtype": foodtype,
            "avgcost": avgcost,
            "geometry": [
                "coordinates": [latitude, longitude]
                ]
            ]
        do {
            //Serialize json
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: POST_ADD_FT) else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
            
            guard let token = AuthService.instance.authToken else {
                completion(false)
                return
            }
            
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if error == nil {
                    //Success
                    //Check for status code 200. If statusCode != 200 then the process was NOT successful
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL session succeeded : HTTP \(statusCode)")
                    if statusCode != 200 {
                        completion(false)
                        return
                    } else {
                        self.getAllFoodTrucks()
                        completion(true)
                    }
                } else {
                    //Failure
                    print("URL session task failed: \(error)")
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
        } catch let err {
            completion(false)
            print(err)
        }
        
        //POST add a new foodtruck review
        func addNewReview(_ foodtruckId: String, title: String, text: String, completion: @escaping callback) {
            let json: [String: Any] = [
                "title": title,
                "text": text,
                "foodtruck": foodtruckId
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                let sessionConfig = URLSessionConfiguration.default
                let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
                
                guard let URL = URL(string: "\(POST_ADD_REVIEW)/\(foodtruckId)") else { return }
                var request = URLRequest(url: URL)
                request.httpMethod = "POST"
                
                guard let token = AuthService.instance.authToken else {
                    completion(false)
                    return
                }
                
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpBody = jsonData
                
                let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    if error == nil {
                        //Success
                        let statusCode = (response as! HTTPURLResponse).statusCode
                        print("Url session task succeeded : HTTP \(statusCode)")
                        //Check for 200 statusCode
                        if statusCode != 200{
                            completion(false)
                            return
                        } else {
                            completion(true)
                        }
                    } else {
                        //Failure
                        print("Url session task failed: \(error?.localizedDescription)")
                        completion(false)
                    }
                })
                task.resume()
                session.finishTasksAndInvalidate()
                
            } catch let err {
                print(err)
                completion(false)
            }
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
