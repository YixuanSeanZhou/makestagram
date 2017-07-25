//
//  HomeViewController.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/24.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


class HomeViewController : UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    
        func configureTableView() {
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        // remove separators from cells
        tableView.separatorStyle = .none
    }
    //fetch our posts from Firebase:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        // ...
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
    }

    
    
}
//Now our table view will display the same number of cells as in our posts array
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as! PostHeaderCell
            cell.usernameLabel.text = User.current.username
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell") as! PostImageCell
            let imageURL = URL(string: post.imageURL)
            
            cell.postImageCell.kf.setImage(with: imageURL)
            
            return cell
            
        case 2:
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell") as! PostActionCell
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
}



// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                return PostHeaderCell.height
                
            case 1:
                let post = posts[indexPath.section]
                print (post.imageHeight)
                return post.imageHeight
                
            case 2:
                return PostActionCell.height
                
            default:
                fatalError()
        }
    }
}
