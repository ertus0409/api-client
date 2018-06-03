//
//  AddTruckVC.swift
//  api-client
//
//  Created by Guner Babursah on 01/06/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import UIKit

class AddTruckVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var avgCostField: UITextField!
    @IBOutlet weak var foodTypeField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func cancelBUttonTapped(sender: UIButton) {
        self.dismissViewController()
    }
    
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewController()
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

}
