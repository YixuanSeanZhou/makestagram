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
        
        // 1
        guard let user = user
            else { return }
        
        // 2
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        // 3
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
            UserService.show(forUID: user.uid) { (user) in
                if let user = user {
                    // handle existing user
                    User.setCurrent(user, writeToUserDefaults: true)
                    
                    let initialViewController = UIStoryboard.initialViewController(for: .main)
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                } else {
                    // handle new user
                    self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
                }
            }
        }
    )}
}
