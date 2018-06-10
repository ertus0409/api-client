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
    @IBOutlet weak var searchBar: UISearchBar!
    
    //VARIABLES
    var dataService = DataService.instance
    var authService = AuthService.instance
    var filteredData = [FoodTruck]()
    var isSearching = false
    var logInVC: LogInVC!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.instance.getAllFoodTrucks()
        tableView.reloadData()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func showLogInVC() {
        logInVC = LogInVC()
        logInVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(logInVC, animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(sender: UIButton){
        if authService.isAuthenticated == true {
            performSegue(withIdentifier: "showAddTruckVC", sender: self)
        } else {
            showLogInVC()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsVC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! DetailsVC
                if isSearching {
                    destinationViewController.selectedFoodTruck = filteredData[indexPath.row]
                } else {
                    destinationViewController.selectedFoodTruck = dataService.foodTrucks[indexPath.row]
                }
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

extension MainVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        }
        return dataService.foodTrucks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTruckCell", for: indexPath) as? FoodTruckCell {
            if isSearching {
                cell.configureCell(truck: filteredData[indexPath.row])
            } else {
                cell.configureCell(truck: dataService.foodTrucks[indexPath.row])
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredData = dataService.foodTrucks.filter({$0.name.range(of: searchBar.text!) != nil})
            tableView.reloadData()
        }
    }
}

