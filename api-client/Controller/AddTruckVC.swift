//
//  AddTruckVC.swift
//  api-client
//
//  Created by Guner Babursah on 01/06/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import UIKit

class AddTruckVC: UIViewController, UITextFieldDelegate {
    
    
    //VARIABLES:
    var selectedFoodtruck: FoodTruck?
    
    
    //IBOUTLETS:
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var avgCostField: UITextField!
    @IBOutlet weak var foodTypeField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addTruckBtn: UIButton!
    @IBOutlet weak var chooseLocBtn: UIButton!
    
    static let instance = AddTruckVC()
    static var mapLatitude: String?
    static var mapLongitude: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        avgCostField.delegate = self
        foodTypeField.delegate = self
        latitudeField.delegate = self
        longitudeField.delegate = self

        if let truck = selectedFoodtruck {
            nameLbl.text = "Update Truck"
            nameField.text = truck.name
            avgCostField.text = "\(truck.avgCost)"
            foodTypeField.text = truck.foodtype
            latitudeField.text = "\(truck.lat)"
            longitudeField.text = "\(truck.long)"
            addTruckBtn.setTitle("Update Truck", for: UIControlState.normal)
        } else {
            nameLbl.text = "Add New Truck"
            addTruckBtn.setTitle("Add New Truck", for: UIControlState.normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("CO: \(AddTruckVC.mapLongitude)   \(AddTruckVC.mapLongitude)")
        
        guard let lat = AddTruckVC.mapLatitude else { return }
        guard let long = AddTruckVC.mapLongitude else { return }
        
        latitudeField.text = lat
        longitudeField.text = long
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        AddTruckVC.mapLongitude = nil
        AddTruckVC.mapLatitude = nil
    }
    
    
    
    
    @IBAction func addButtonTapped(sender: UIButton) {
        guard let name = nameField.text, nameField.text != "" else {
            showAlert(with: "Error", message: "Please enter a name")
            return
        }
        guard let foodtype = foodTypeField.text, foodTypeField.text != "" else {
            showAlert(with: "Error", message: "Please enter a foodtype")
            return
        }
        guard let avgcost = Double(avgCostField.text!), avgCostField.text != "" else {
            showAlert(with: "Error", message: "Please enter an average cost")
            return
        }
        guard let long = Double(longitudeField.text!), longitudeField.text != "" else {
            showAlert(with: "Error", message: "Please enter a longitude decimal value")
            return
        }
        guard let lat = Double(latitudeField.text!), latitudeField.text != "" else {
            showAlert(with: "Error", message: "Please enter a latitude decimal value")
            return
        }
        
        if let truck = selectedFoodtruck {
            DataService.instance.updateTruck(truck.id, name: name, avgCost: Double(avgcost), foodtype: foodtype, latitude: Double(lat), longitude: Double(long), completion: { (Success) in
                if Success {
                    print("Foodtruck UPDATED successfully")
                    self.dismissViewController()
                } else {
                    self.showAlert(with: "Error", message: "Couldn't update truck info")
                    print("Couldn't update truck!")
                }
            })
        } else {
            DataService.instance.addNewTruck(name, foodtype: foodtype, avgcost: avgcost, latitude: lat, longitude: long) { (Success) in
                if Success {
                    print("FoodTruck successfully saved!")
                    self.dismissViewController()
                } else {
                    self.showAlert(with: "Error", message: "Couldn't save food truck due to an unkown error!")
                    print("Couldn't save FoodTruck!")
                }
            }
        }
        
    }
    
    @IBAction func cancelBUttonTapped(sender: UIButton) {
        self.dismissViewController()
    }
    
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewController()
    }
    
    @IBAction func chooseLocationFromMapTapped(sender: UIButton) {
        performSegue(withIdentifier: "mapSelectVC", sender: self)
    }
    
    func dismissViewController() {
        OperationQueue.main.addOperation {
            let main = self.navigationController?.viewControllers[0] as! MainVC
            self.navigationController?.popToViewController(main, animated: true)
        }
    }
    
    
    //Alert
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: title, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    //Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapSelectVC" {
            let destination = segue.destination as! MapSelectVC
            if let truck = self.selectedFoodtruck {
                destination.selectedFoodTruck = truck
            }
        }
    }
    
    
    //TextField Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}









