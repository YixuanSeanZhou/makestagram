//
//  Storyboard+Utility.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/24.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum MGType: String {
        case main
        case login
        
        var filename: String {
            return rawValue.capitalized
        }
    }
}
