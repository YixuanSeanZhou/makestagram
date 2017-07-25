//
//  UserService.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/23.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService{
    // insert user-related networking code here
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot)
            else {
                return completion(nil)
            }
            completion(user)
        })
    }
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        // A dictionary to store the username
        let userAttrs = ["username": username]
        // Find the location we want to store our info on Firebase
        let ref = Database.database().reference().child("users").child(firUser.uid)
        // Set value and update to database
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            // We read the user we just wrote to the database and create a user from the snapshot
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    //Next we need a service method that will retrieve all of a user's posts from Firebase.
    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let posts = snapshot.reversed().flatMap(Post.init)
            completion(posts)
        })
    }
}
