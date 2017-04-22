//
//  WineListViewController.swift
//  Wine Rack
//
//  Created by David Gibbs on 06/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import UIKit

class WineListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var wineListTableView: UITableView!
    @IBOutlet weak var wineRackNavBar: WRNavBar!
    @IBOutlet weak var noWinesView: UIView!
    @IBOutlet weak var noWinesLabel: UILabel!
    
    // MARK: IBActions
    
    @IBAction func openSearchController(_ sender: UIBarButtonItem) {
    }
    
    // MARK: Variables/Constants
    
    var dummyBool: Bool = true
    
    var savedWines: Bool {
        get {
            return dummyBool
        }
    }
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set nav bar style
        wineRackNavBar.setBarBackgroundColor(UIColor.wineRackLightRed)
        
        // Set view depending on whether user has saved wines
        hasSavedWines(savedWines)
    }
    
    // MARK: Private methods
    
    func hasSavedWines(_ wines: Bool) {
        if wines {
            wineListTableView.isHidden = false
            noWinesView.isHidden = true
        } else {
            wineListTableView.isHidden = true
            noWinesView.isHidden = false
            noWinesLabel.text = Constants.NoWinesLabel.WineList
            noWinesLabel.textColor = UIColor.wineRackLightRed
        }
    }
    
    // MARK: Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WineCell")!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // CODE HERE
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // CODE HERE
    }

    // MARK: Extensions
    
    

    
    
}
