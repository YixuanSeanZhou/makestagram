//
//  HomeViewController.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/24.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI
import Kingfisher


class HomeViewController : UIViewController{
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    var posts = [Post]()
    
        func configureTableView() {
            // remove separators for empty cells
            tableView.tableFooterView = UIView()
            // remove separators from cells
            tableView.separatorStyle = .none
            
            // add pull to refresh
            refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
            tableView.addSubview(refreshControl)
    
    }
    //fetch our posts from Firebase:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        reloadTimeline()
    }
    
    func reloadTimeline() {
        UserService.timeline { (posts) in
            self.posts = posts
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
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
            cell.usernameLabel.text = post.poster.username
            
            return cell

            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell") as! PostImageCell
            let imageURL = URL(string: post.imageURL)
            
            cell.postImageCell.kf.setImage(with: imageURL)
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell") as! PostActionCell
            cell.delegate = self
            configureCell(cell, with: post)
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func configureCell(_ cell: PostActionCell, with post: Post) {
        cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
        cell.likeButton.isSelected = post.isLiked
        cell.likeCountLabel.text = "\(post.likeCount) likes"
    }
}

let timestampFormatter : DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    return dateFormatter
}()



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

extension HomeViewController: PostActionCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {
        // dex path exists
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        
        // Set the isUserInteractionEnabled property to false so the user doesn't accidentally send multiple requests by tapping too quickly.
        likeButton.isUserInteractionEnabled = false
        // Reference the correct post corresponding with the PostActionCell that the user tapped.
        let post = posts[indexPath.section]
        
        // Use our LikeService to like or unlike the post based on the isLiked property.
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
            // Use defer to set isUserInteractionEnabled to true whenever the closure returns.
            defer {
                likeButton.isUserInteractionEnabled = true
            }
            
            // Basic error handling if something goes wrong with our network request
            guard success else { return }
            
            // Change the likeCount and isLiked properties of our post if our network request was successful.
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked
            
            // Get a reference to the current cell.
            guard let cell = self.tableView.cellForRow(at: indexPath) as? PostActionCell
                else { return }
            
            // Update the UI of the cell on the main thread. Remember that all UI updates must happen on the main thread.
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
    }
}
