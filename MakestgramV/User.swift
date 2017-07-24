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
    
    // MARK: - Singleton
    
    // Create a private static variable to hold our current user. This method is private so it can't be access outside of this class.
    private static var _current: User?
    
    // Create a computed variable that only has a getter that can access the private _current variable.
    static var current: User {
        // Check that _current that is of type User? isn't nil. If _current is nil, and current is being read, the guard statement will crash with fatalError().
        guard let currentUser = _current
        else {
            fatalError("Error: current user doesn't exist")
        }
        
        // If _current isn't nil, it will be returned to the user.
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // Create a custom setter method to set the current user.
    static func setCurrent(_ user: User) {
        _current = user
    }

    
}
