//
//  User.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/21.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

class User {
    
    // MARK: - Properties
    
    let uid: String
    let username: String
    // MARK: - Init
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
    }

    // If the initialization of an object fail,  
    //if a user doesn't have a UID or a username, we'll fail the initialization and return nil.
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key

        self.username = username
    }
    
}
