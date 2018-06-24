//
//  Constants.swift
//  api-client
//
//  Created by Guner Babursah on 16/03/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import Foundation

//Callbacks :
//Typealias used for callbacks DataService
typealias callback = (_ success: Bool) -> ()

//Base Url
let BASE_API_URL = "http://appstoredomain.com/api/v1"

//Get all foodtrucks
let GET_ALL_FT_URL = "\(BASE_API_URL)/foodtruck"

//Get all reviews for a specific food truck
let GET_ALL_FT_REVIEWS = "\(BASE_API_URL)/foodtruck/reviews"

//POST add foodtruck
let POST_ADD_FT = "\(BASE_API_URL)/foodtruck/add"

//POST add review
let POST_ADD_REVIEW = "\(BASE_API_URL)/foodtruck/reviews/add"

//PUT update truck
let PUT_UPDT_FT = "\(BASE_API_URL)/foodtruck"

//DELETE truck
let DELETE_FT = "\(BASE_API_URL)/foodtruck/"

//Boolean Auth UserDefaults keys
let DEFAULTS_REGISTERED = "isRegistered"
let DEFAULTS_AUTHENTICATED = "isAuthenticated"

//Auth Email
let DEFAULTS_EMAIL = "email"

//Auth Toekn
let DEFAULTS_TOKEN = "authToken"

//REGISTER URL
let POST_REGISTER_ACCT = "\(BASE_API_URL)/account/register"

//LOGIN URL
let POST_LOGIN_ACCT = "\(BASE_API_URL)/account/login"
