//
//  LoginViewController.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/21.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController{
    
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
        print("LoginButtonTapped")
    }
    
}
