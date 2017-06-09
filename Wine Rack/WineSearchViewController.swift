//
//  WineSearchViewController.swift
//  Wine Rack
//
//  Created by David Gibbs on 09/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

protocol WineRackTableDelegate {
    func wineRackIsUpdated()
}

class WineSearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var wineRackNavBar: WRNavBar!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: IBActions
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        searchTextField.resignFirstResponder()
        
        do {
            try stack.saveContext()
        } catch {
            fatalError("Context cannot be saved")
        }
        
        self.dismiss(animated: true) {
            self.wineRackDelegate?.wineRackIsUpdated()
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        fetchSearchRequest()
        self.wineRackDelegate?.wineRackIsUpdated()
    }
    
    // MARK: Variables/Constants
    
    var wineRackDelegate: WineRackTableDelegate? = WineListViewController()
    
    let stack = CoreDataStack.sharedInstance()
    var wineArray = [Wine]()
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide tableview and activity indicator
        searchResultsTableView.isHidden = true
        activityIndicator.stopAnimating()
        
        // Open keyboard
        searchTextField.becomeFirstResponder()
        
        // Override background and nav bar color
        self.view.backgroundColor = UIColor.darkGray
        wineRackNavBar.setBarBackgroundColor(UIColor.darkGray)
        
        // Set style for status bar
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
        let statusBar = UIView(frame: frame)
        statusBar.backgroundColor = UIColor.darkGray
        self.view.addSubview(statusBar)
        
        // Set style of textfield
        searchTextField.layer.cornerRadius = 25.0
        
        // Set style of button
        searchButton.backgroundColor = UIColor.wineRackLightRed
        searchButton.layer.cornerRadius = 25.0
        
        // Register nib
        searchResultsTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        
        self.searchResultsTableView.rowHeight = UITableViewAutomaticDimension
        self.searchResultsTableView.estimatedRowHeight = 120.00
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Private methods
    
    func fetchSearchRequest() {
        wineArray.removeAll()
        searchResultsTableView.isHidden = true
        self.activityIndicator.startAnimating()
        searchTextField.resignFirstResponder()
        
        WineAPIClient.sharedInstance().searchforWine(searchquery: searchTextField.text!) { (result, error) in
            if error == nil {
                
                guard let products = result?["Products"] else {
                    print("ERROR IN GUARD FOR PRODUCTS")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    return
                }
                
                guard let wineList = products["List"] else {
                    print("ERROR IN GUARD FOR LIST")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    return
                }
                
                guard let totalResults = products["Total"], totalResults as! Int > 0 else {
                    
                    let alert = UIAlertController(title: "No results found", message: "There were no results for your search. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    return
                }
                
                // Iterate over results
                for wine in wineList as! [AnyObject] {
                    
                    var searchedWine: Wine?
                    
                    if let wineDict = wine as? [String: AnyObject] {
                        if let wineID = wineDict["Id"] as? Int32 {
                            if let savedWine = DataManager.sharedInstance().findWineById(wineID) {
                                searchedWine = savedWine
                            } else {
                                searchedWine = Wine(context: self.stack.context, dictionary: wineDict)
                            }
                        }
                    }
                    
                    self.wineArray.append(searchedWine!)
                }
                
                DispatchQueue.main.async {
                    self.searchResultsTableView.isHidden = false
                    self.activityIndicator.stopAnimating()
                    self.searchResultsTableView.reloadData()
                }
            }
        }
    }
    
    // MARK: Delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchSearchRequest()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchTableViewCell
        
        cell.nameLabel.text = wineArray[indexPath.row].name
        cell.typeLabel.text = wineArray[indexPath.row].wineType
        cell.vintageLabel.text =  wineArray[indexPath.row].vintage
        cell.infoUrl = wineArray[indexPath.row].url
        
        if let url = wineArray[indexPath.row].labelUrl {
            cell.downloadImage(imageUrl: url) { (data, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        cell.labelImageView.image = UIImage(data: data!)
                    }
                }
            }
        } else {
            print("NO IMAGE")
        }
        
        cell.wineRackButton.tag = indexPath.row
        cell.wishListButton.tag = indexPath.row
        
        cell.wineRackButton.addTarget(self, action: #selector(addWineToRack(_:)), for: .touchUpInside)
        cell.wishListButton.addTarget(self, action: #selector(addWineToWishList(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func addWineToRack(_ sender: UIButton) {
        wineArray[sender.tag].inWineRack = true
        wineArray[sender.tag].onWishlist = false
    }
    
    func addWineToWishList(_ sender: UIButton) {
        wineArray[sender.tag].inWineRack = false
        wineArray[sender.tag].onWishlist = true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.allowsSelection = false
    }

}
