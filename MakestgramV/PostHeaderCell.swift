//
//  PostHeaderCell.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/25.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit

class PostHeaderCell: UITableViewCell {
    static let height: CGFloat = 54
    
    @IBOutlet weak var usernameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
    }
    
}
