//
//  WineRackTabBarController.swift
//  Wine Rack
//
//  Created by David Gibbs on 07/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import UIKit

class WineRackTabBarController: UITabBarController {
    
    // MARK: IBOutlets
    // MARK: IBActions
    // MARK: Variables/Constants
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set tab bar background color
        self.tabBar.barTintColor = UIColor.wineRackLightRed
        
        // Set selected UITabBarItem
        self.tabBar.tintColor = UIColor.white
        
        self.tabBar.unselectedItemTintColor = UIColor.wineRackPink
        
        // Make solid color
        self.tabBar.isTranslucent = false
        
        // Set style for status bar
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
        let statusBar = UIView(frame: frame)
        statusBar.backgroundColor = UIColor.wineRackLightRed
        self.view.addSubview(statusBar)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Private methods
    
    
    // MARK: Delegate methods
    
    
    
    // MARK: Extensions
    

    
    
    

}

