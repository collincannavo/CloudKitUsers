//
//  UserViewController.swift
//  CloudKitUsers
//
//  Created by Collin Cannavo on 6/21/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: UserController.shared.currentUserWasSetNotification, object: nil)
    }
    
    //The selector is a function, or something that happens once it receives the notification - or signal - to do something. The selector has to be another function outside the method. 
    
    func refresh() {
        
        guard let currentUser = UserController.shared.currentUser else { return }
        
        usernameLabel.text = currentUser.username
        emailLabel.text = currentUser.email
        ageLabel.text = currentUser.age
        
        
    }
  
    @IBAction func saveUserButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let username = usernameTextField.text,
            let age = ageTextField.text else { return }
        
        UserController.shared.createUser(username: username, email: email, age: age)
        
    }

}
