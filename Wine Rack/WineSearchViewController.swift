//
//  WineSearchViewController.swift
//  Wine Rack
//
//  Created by David Gibbs on 09/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import UIKit
import QuartzCore

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
        self.dismiss(animated: true) { 
            self.wineRackDelegate?.wineRackIsUpdated()
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        fetchSearchRequest()
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
        // Dispose of any resources that can be recreated.
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
                    // TODO: Add a notification over top of view
                    print("NO RESULTS")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    return
                }
                
                // Iterate over results
                for wine in wineList as! [AnyObject] {
                    let searchedWine = Wine(context: self.stack.context, dictionary: wine as! [String: AnyObject])
                    self.wineArray.append(searchedWine)
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
        
        return cell
    }
    
    func addWineToRack(_ sender: UIButton) {
        wineArray[sender.tag].inWineRack = true
        wineRackDelegate?.wineRackIsUpdated()
        
        do {
            try stack.saveContext()
        } catch {
            fatalError("Context cannot be saved")
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.allowsSelection = false
    }

    
    // MARK: Extensions
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
