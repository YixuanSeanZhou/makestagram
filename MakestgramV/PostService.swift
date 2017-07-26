//
//  PostService.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/25.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight)
        }
    }
    // create new post in database
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {

        // Create a reference to the current user. 
        //need the user's UID to construct the location of where we'll store our post data in our database.
        let currentUser = User.current
    
        // Initialize a new Post using the data passed in by the parameters.
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        
        //We create references to the important locations that we're planning to write data.
        let rootRef = Database.database().reference()
        let newPostRef = rootRef.child("posts").child(currentUser.uid).childByAutoId()
        let newPostKey = newPostRef.key
        
        // Convert the new post object into a dictionary so that it can be written as JSON in our database.
        // Use our class method to get an array of all of our follower UIDs
        UserService.followers(for: currentUser) { (followerUIDs) in
            // We construct a timeline JSON object where we store our current user's uid.
            let timelinePostDict = ["poster_uid" : currentUser.uid]
            
            // We create a mutable dictionary that will store all of the data we want to write to our database.
            var updatedData: [String : Any] = ["timeline/\(currentUser.uid)/\(newPostKey)" : timelinePostDict]
            
            // We add our post to each of our follower's timelines.
            for uid in followerUIDs {
                updatedData["timeline/\(uid)/\(newPostKey)"] = timelinePostDict
            }
            
            // We make sure to write the post we are trying to create.
            let postDict = post.dictValue
            updatedData["posts/\(currentUser.uid)/\(newPostKey)"] = postDict
            
            // We write our multi-location update to our database.
            rootRef.updateChildValues(updatedData)
        }
    }
    
    static func show(forKey postKey: String, posterUID: String, completion: @escaping (Post?) -> Void) {
        let ref = Database.database().reference().child("posts").child(posterUID).child(postKey)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }
            
            LikeService.isPostLiked(post) { (isLiked) in
                post.isLiked = isLiked
                completion(post)
            }
        })
    }
    
}

