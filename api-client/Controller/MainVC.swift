//
//  MainVC.swift
//  api-client
//
//  Created by Guner Babursah on 27/02/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    //IBOUTLETS:
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    
    //VARIABLES
    var dataService = DataService.instance
    var authService = AuthService.instance
    
    var logInVC: LogInVC!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.instance.getAllFoodTrucks()
        tableView.reloadData()
    }
    
    func showLogInVC() {
        logInVC = LogInVC()
        logInVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(logInVC, animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(sender: UIButton){
        if AuthService.instance.isAuthenticated == true {
            performSegue(withIdentifier: "showAddTruckVC", sender: self)
        } else {
            showLogInVC()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsVC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! DetailsVC
                destinationViewController.selectedFoodTruck = DataService.instance.foodTrucks[indexPath.row]
            }
        }
    }

    


}
extension MainVC: DataServiceDelegate {
    func trucksLoaded() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
    func reviewsLoaded() {
        // Do nothing
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataService.foodTrucks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTruckCell", for: indexPath) as? FoodTruckCell {
            cell.configureCell(truck: dataService.foodTrucks[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

