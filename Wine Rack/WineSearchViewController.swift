//
//  WineSearchViewController.swift
//  Wine Rack
//
//  Created by David Gibbs on 09/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import UIKit
import QuartzCore

class WineSearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var wineRackNavBar: WRNavBar!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    // MARK: IBActions
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        searchTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        fetchSearchRequest()
    }
    
    func fetchSearchRequest() {
        self.wineArray.removeAll()
        
        searchTextField.resignFirstResponder()
        
        WineAPIClient.sharedInstance().searchforWine(searchquery: searchTextField.text!) { (result, error) in
            if error == nil {
                guard let products = result?["Products"] else {
                    print("ERROR IN GUARD FOR PRODUCTS")
                    return
                }
                
                guard let wineList = products["List"] else {
                    print("ERROR IN GUARD FOR LIST")
                    return
                }
                
                for wine in wineList as! [AnyObject] {
                    let searchedWine = Wine(dictionary: wine as! [String: AnyObject])
                    
                    self.wineArray.append(searchedWine)
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.searchResultsTableView.reloadData()
                }
            }
        }
    }
    
    // MARK: Variables/Constants
    
    var wineArray = [Wine]()
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        tableView.register(UINib(nibName: "PhotoPostTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoPostCell")
        searchResultsTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        
        self.searchResultsTableView.rowHeight = UITableViewAutomaticDimension
        self.searchResultsTableView.estimatedRowHeight = 120.00
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private methods
    
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // CODE HERE
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // CODE HERE
    }

    
    // MARK: Extensions
    

    
    // MARK: TextField methods
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
