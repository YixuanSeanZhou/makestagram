//
//  CreateUsernameViewController.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/23.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {
    // ...
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    //VC life Cycle
    override func viewDidLoad() {
        
        nextButton.layer.cornerRadius = 6
    }
    //MARK : IBAction


    @IBAction func nextButtonTapped(_ sender: UIButton) {
    //creat new user database and enter username
        guard let firUser = Auth.auth().currentUser,
            let username = userNameTextField.text,
            !username.isEmpty else {
                return
        }
        // Call UserService
        UserService.create(firUser, username: username) { (user) in
            guard let user = user
                else {
                    return
            }
            
            print("Created new user: \(user.username)")

        }
        //Create a new instance of our main storyboard
        UserService.create(firUser, username: username) { (user) in
            //Check that the storyboard has an initial view controller
            guard let user = user
                else {
                return
            }
            
            User.setCurrent(user)
            
            //Get reference to the current window and set the rootViewController to the initial view controller
            let storyboard = UIStoryboard(name: "Main", bundle: .main)

            
            if let initialViewController = storyboard.instantiateInitialViewController() {
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
            else {
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        }
    }

}
