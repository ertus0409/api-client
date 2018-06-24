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
    
//    static let instance = DetailsVC()
    

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setTruck()

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if let truckId = selectedFoodTruck?.id {
//            DataService.instance.getTruckById(id: truckId)
//            selectedFoodTruck = DataService.instance.selectedTruck
//        }
//    }
    
    
    func setTruck(){
        nameLbl.text = selectedFoodTruck?.name
        foodTypeLbl.text = selectedFoodTruck?.foodtype.capitalized
        avgCostLbl.text = "$\(selectedFoodTruck!.avgCost)"
        
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
        } else if segue.identifier == "updateTruck" {
            let destinationViewController = segue.destination as! AddTruckVC
            destinationViewController.selectedFoodtruck = selectedFoodTruck
        }
    }
    
    @IBAction func reviewsButtonTapped() {
        performSegue(withIdentifier: "showReviewsVC", sender: self)
    }
    @IBAction func addReviewButtonTapped() {
        if AuthService.instance.isAuthenticated! {
            performSegue(withIdentifier: "showAddReviewVC", sender: self)
        } else {
            showLogInVC()
        }
    }
    
    func showLogInVC() {
        logInVc = LogInVC()
        logInVc?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(logInVc!, animated: true, completion: nil)
    }
    
    
    @IBAction func updateTruckTapped(_ sender: Any) {
        if AuthService.instance.isAuthenticated! {
            performSegue(withIdentifier: "updateTruck", sender: self)
        } else {
            showLogInVC()
        }
        
    }
    
    @IBAction func deleteTruckTapped() {
        let checkingAlert = UIAlertController(title: "Deleting FoodTruck", message: "Are you sure you want to delete this truck", preferredStyle: .alert)
        
        checkingAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            if let truck = self.selectedFoodTruck {
                DataService.instance.deleteTruck(truck.id, completion: { (Success) in
                    if Success {
                        print("FoodTruck deleted successfully")
                        DataService.instance.getAllFoodTrucks()
                        self.dismissViewController()
                    } else {
                        print("An error occured")
                    }
                })
            } else {
                
            }
            
        }))
        
        checkingAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        present(checkingAlert, animated: true, completion: nil)
 
    }
    
    
    func dismissViewController() {
        OperationQueue.main.addOperation {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: title, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    

    

}
extension DetailsVC: DataServiceDelegate {
    func trucksLoaded() {
//        setTruck()
    }
    
    func reviewsLoaded() {
        
    }
}
