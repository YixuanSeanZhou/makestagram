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
    //creat new user database
        guard let firUser = Auth.auth().currentUser,
            let username = userNameTextField.text,
            !username.isEmpty else { return }
        
        // 2
        let userAttrs = ["username": username]
        
        // 3
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        // 4
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            // 5
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                
                // handle newly created user here
            })
        }
    }



}
