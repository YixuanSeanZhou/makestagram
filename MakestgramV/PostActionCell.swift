//
//  PostActionCell.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/25.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol PostActionCellDelegate: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell)
}
//Difference between declear a func?????

class PostActionCell : UITableViewCell{
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    
    weak var delegate: PostActionCellDelegate?
    static let height: CGFloat = 46
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func likeButtonTapped(_ sender: UIButton) {
       delegate?.didTapLikeButton(sender, on: self)
    }
    
    
    
}
