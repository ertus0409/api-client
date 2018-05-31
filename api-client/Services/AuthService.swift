//
//  AuthService.swift
//  api-client
//
//  Created by Guner Babursah on 27/03/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import Foundation

class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isRegistered: Bool? {
        get{
            return defaults.bool(forKey: DEFAULTS_REGISTERED) == true
        }
        set{
            defaults.set(newValue, forKey: DEFAULTS_REGISTERED)
        }
    }
    
    var isAuthenticated: Bool? {
        get {
            return defaults.bool(forKey: DEFAULTS_AUTHENTICATED) == true
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_AUTHENTICATED)
        }
    }
    
    var email: String? {
        get{
            return defaults.value(forKey: DEFAULTS_EMAIL) as? String
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_EMAIL)
        }
    }
    
    var authToken: String? {
        get {
            return defaults.value(forKey: DEFAULTS_TOKEN) as? String
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_TOKEN)
        }
    }
    
    func registerUser(email username: String, password: String, completion: @escaping callback) {
        
        let json = ["email": username, "password": password]
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: POST_REGISTER_ACCT) else {
            isRegistered = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if error == nil {
                    //Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL session task succeeded \(statusCode)")
                    
                    //Check for 200 or 409
                    if statusCode != 200 && statusCode != 409 {
                        self.isRegistered = false
                        completion(false)
                        return
                    } else {
                        self.isRegistered = true
                        completion(true)
                    }
                } else {
                    //Failure
                    print("URL Session task failed : ",error)
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
        } catch let err {
            self.isRegistered = false
            completion(false)
            print(err)
        }
    }
    
    
    func logIn(email username: String, password: String, completion: @escaping callback) {
        let json = ["email": username, "password": password]
        
        let sessionConnfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConnfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: POST_LOGIN_ACCT) else {
            isAuthenticated = false
            completion(false)
            return
        }
        
        print("pass01")
        
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if error == nil {
                    //Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL sessionn succeeded: HTTP \(statusCode)")
                    if statusCode != 200 {
                        //Failed
                        completion(false)
                        return
                    } else {
                        guard let data = data else {
                            completion(false)
                            return
                        }
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, AnyObject>
                            
                            if result != nil {
                                if let email = result?["user"] as? String {
                                    if let token = result?["token"] as? String {
                                        //Successfully authenticated and have a token
                                        self.email = email
                                        self.authToken = token
                                        self.isRegistered = true
                                        self.isAuthenticated = true
                                        completion(true)
                                    } else {
                                        completion(false)
                                    }
                                }else {
                                    completion(false)
                                }
                            } else {
                                completion(false)
                            }
                        } catch let err {
                            completion(false)
                            print(err)
                        }
                    }
                } else {
                    //Failure
                    print("URL sesion task failed : \(error?.localizedDescription)")
                    completion(false)
                    return
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            completion(false)
            print(err)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
