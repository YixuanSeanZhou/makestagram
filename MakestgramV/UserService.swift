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
            
            let dispatchGroup = DispatchGroup()
            
            let posts: [Post] =
                snapshot
                    .reversed()
                    .flatMap {
                        guard let post = Post(snapshot: $0)
                            else { return nil }
                        
                        dispatchGroup.enter()
                        
                        LikeService.isPostLiked(post) { (isLiked) in
                            post.isLiked = isLiked
                            
                            dispatchGroup.leave()
                        }
                        
                        return post
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
        })
    }
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        // Create a DatabaseReference to read all users from the database.
        let ref = Database.database().reference().child("users")
        
        // Read the users node from the database.
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            // Take the snapshot and perform a few transformations.
            let users =
                snapshot
                    .flatMap(User.init)
                    .filter { $0.uid != currentUser.uid }
            
            // Create a new DispatchGroup so that we can be notified when all asynchronous tasks are finished executing. 
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()
                
                // 5
                FollowService.isUserFollowed(user) { (isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                }
            }
            
            // 6
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
    static func followers(for user: User, completion: @escaping ([String]) -> Void) {
        let followersRef = Database.database().reference().child("followers").child(user.uid)
        
        followersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let followersDict = snapshot.value as? [String : Bool] else {
                return completion([])
            }
            
            let followersKeys = Array(followersDict.keys)
            completion(followersKeys)
        })
    }
    
    
    static func timeline(completion: @escaping ([Post]) -> Void) {
        let currentUser = User.current
        
        let timelineRef = Database.database().reference().child("timeline").child(currentUser.uid)
        timelineRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            let dispatchGroup = DispatchGroup()
            
            var posts = [Post]()
            
            for postSnap in snapshot {
                guard let postDict = postSnap.value as? [String : Any],
                    let posterUID = postDict["poster_uid"] as? String
                    else { continue }
                
                dispatchGroup.enter()
                
                PostService.show(forKey: postSnap.key, posterUID: posterUID) { (post) in
                    if let post = post {
                        posts.append(post)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts.reversed())
            })
        })
    }
    
    
}
