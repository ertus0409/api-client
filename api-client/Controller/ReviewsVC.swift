//
//  ReviewsVC.swift
//  api-client
//
//  Created by Guner Babursah on 04/06/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import UIKit

class ReviewsVC: UIViewController {
    
    //VARIABLES:
    var selectedFoodTruck: FoodTruck?
    
    //IBOUTLETS:
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
        

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.instance.delegate = self
        
        if let truck = selectedFoodTruck {
            nameLbl.text = truck.name
            DataService.instance.getAllReviews(for: truck)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
    }
    
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    

}

extension ReviewsVC: DataServiceDelegate {
    func trucksLoaded() {
        
    }
    func reviewsLoaded() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
        if !DataService.instance.reviewsStatus {
            OperationQueue.main.addOperation {
            self.showAlert(with: "Sorry", message: "NO reviws available")
            }
        }
    }
}

extension ReviewsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.reviews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell {
            cell.configureCell(review: DataService.instance.reviews[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
