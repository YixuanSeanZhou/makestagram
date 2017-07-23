//
//  LoginViewController.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/21.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase
typealias FIRUser = FirebaseAuth.User

class LoginViewController : UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Steps after loading the view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //Dispose of resources that can be recreated
    }
   
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        //access the FUIAuth default auth UI singleton
        guard let authUI = FUIAuth.defaultAuthUI()
            else {
                return
        }
        //set FUIAuth's singleton delegate
        authUI.delegate = self
        //present the auth view controller
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
        print("LoginButtonTapped")
    }
    
    
    
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
            
        //First we check that the FIRUser returned from authentication is not nil by unwrapping it.
        guard let user = user
            else {
                return
        }
        let userRef = Database.database().reference().child("users").child(user.uid)
        //check if there is a current user logged into Firebase by checking the Firebase Auth current user singleton.
        if let user = Auth.auth().currentUser {
            //If a FIRUser exists, we get a reference to the root of our JSON dictionary with the Database.database().reference() singleton
            let rootRef = Database.database().reference()
            //We create a DatabaseReference by adding a relative path of /users/#{user.uid}
            let userRef = rootRef.child("users").child(user.uid)
            
            // 1
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // 2 handle snapshot containing data
                //We retrieve the data from the DataSnapshot using the value property. We unwrap and check that the type is what we're expecting it to be, in this case a dictionary.
                if let userDict = snapshot.value as? [String : Any] {
                    print(userDict.debugDescription)
                }
            })
        }
        // We construct a relative path to the reference of the user's information in our database.
        
        // We read from the path we created and pass an event closure to handle the data (snapshot) that is passed back from the database.
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot) {
                print("Welcome back, \(user.username).")
            } else {
                 self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        })
        print("handle user signup / login")
    }
    
}
