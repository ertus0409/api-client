//
//  DetailsVC.swift
//  api-client
//
//  Created by Guner Babursah on 04/06/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import UIKit
import MapKit

class DetailsVC: UIViewController {
    
    //VARIABLES:
    var selectedFoodTruck: FoodTruck?
    var logInVc: LogInVC?
    
    //IBOUTLETS:
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var foodTypeLbl: UILabel!
    @IBOutlet weak var avgCostLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = selectedFoodTruck?.name
        foodTypeLbl.text = selectedFoodTruck?.foodtype.capitalized
        avgCostLbl.text = "\(selectedFoodTruck!.avgCost)"
        
        
        mapView.addAnnotation(selectedFoodTruck!)
        centerMapOnLocation(CLLocation(latitude: selectedFoodTruck!.lat, longitude: selectedFoodTruck!.long))
        

    }
    
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(selectedFoodTruck!.coordinate, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReviewsVC" {
            let destinationViewController = segue.destination as! ReviewsVC
            destinationViewController.selectedFoodTruck = selectedFoodTruck
        } else if segue.identifier == "showAddReviewVC" {
            let destinationViewController = segue.destination as! AddReviewVC
            destinationViewController.selectedFoodTruck = selectedFoodTruck
        }
    }
    
    @IBAction func reviewsButtonTapped() {
        performSegue(withIdentifier: "showReviewsVC", sender: self)
    }
    @IBAction func addReviewButtonTapped() {
        
    }
    
    func showLogInVC() {
        logInVc = LogInVC()
        logInVc?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(logInVc!, animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonTapped(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    

    

}
