//
//  AddReviewVC.swift
//  api-client
//
//  Created by Guner Babursah on 04/06/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import UIKit

class AddReviewVC: UIViewController {
    
    //VARIABLES:
    var selectedFoodTruck: FoodTruck?
    
    //IBOUTLETS:
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var reviewTitleFld: UITextField!
    @IBOutlet weak var reviewTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let truck = selectedFoodTruck {
            headerLbl.text = truck.name
        } else {
            headerLbl.text = "ERROR"
        }

    }
    
    @IBAction func addReviewButtonTapped(sender: UIButton) {
        
        guard let truck = selectedFoodTruck else {
            showAlert(with: "Error", message: "Could not get selected truck")
            return
        }
        guard let title = reviewTitleFld.text, reviewTitleFld.text != "" else {
            showAlert(with: "Error", message: "Please enter title for your review")
            return
        }
        guard let reviewText = reviewTextView.text, reviewTextView.text != "" else {
            showAlert(with: "Error", message: "Please enter some text for your review")
            return
        }
        
        DataService.instance.addNewReview(truck.id, title: title, text: reviewText) { (Success) in
            if Success {
                print("Review saved successfully")
                DataService.instance.getAllReviews(for: truck)
                self.dismissViewController()
            } else {
                self.showAlert(with: "Error", message: "An error occured saving the new review")
                print("Save was unsuccessful")
            }
        }
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        dismissViewController()
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
        let okAction = UIAlertAction(title: "Error", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
