//
//  WRNavBar.swift
//  Wine Rack
//
//  Created by David Gibbs on 07/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import UIKit

class WRNavBar: UINavigationBar {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Set color of bar items
        self.tintColor = UIColor.white
        
        // Remove translucency from navigation bar
        self.isTranslucent = false
        
        // Set bar title color
        self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

    }
    
    func setBarBackgroundColor(_ color: UIColor) {
        self.barTintColor =  color
    }

}
