//
//  LogInVC.swift
//  api-client
//
//  Created by Guner Babursah on 31/03/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {
    
    //IBOUTLETS:
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtnTapped(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginBtnTapped(sender: UIButton) {
        
        guard let email = emailTxtField.text, emailTxtField.text != "", let pass = passwordTxtField.text, passwordTxtField.text != "" else {
            self.showAlert(with: "Error", message: "Please enter an email and a password to continue.")
            return
        }
        
        AuthService.instance.logIn(email: email, password: pass, completion: { Success in
            if Success {
                self.dismiss(animated: true, completion: nil)
            } else {
//                OperationQueue.main.addOperation {
//                    self.showAlert(with: "Error", message: "Incorrect credentials!")
//                }
            }
        })
    
    }
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    

}
