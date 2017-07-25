//
//  StorageReference+Post.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/25.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import FirebaseStorage


//will generate a new location for each new post image that is created by the current ISO timestamp.
extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostImageReference() -> StorageReference {
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
}
