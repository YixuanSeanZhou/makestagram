       //
//  MainTabBarController.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/24.
//  Copyright © 2017年 Thomas. All rights reserved.
//
import UIKit
import Foundation

class MainTabBarController: UITabBarController {
    // MARK: - Properties
    
    let photoHelper = MGPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // closure, a function without name
       photoHelper.completionHandler = { image in
            PostService.create(for: image)
        }
        
        delegate = self
        tabBar.unselectedItemTintColor = .black

    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.tabBarItem.tag == 1 {
            photoHelper.presentActionSheet(from: self)
            return false
        }
        
        return true
    }
}
