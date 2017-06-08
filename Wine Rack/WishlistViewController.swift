//
//  WishlistViewController.swift
//  Wine Rack
//
//  Created by David Gibbs on 06/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import UIKit
import CoreData

class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, WineRackTableDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var wineListTableView: UITableView!
    @IBOutlet weak var wineRackNavBar: WRNavBar!
    @IBOutlet weak var noWinesView: UIView!
    @IBOutlet weak var noWinesLabel: UILabel!
    
    // MARK: Variables/Constants
    
    let stack = CoreDataStack.sharedInstance()
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Wine")
        fr.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fr.predicate = NSPredicate(format: "onWishlist == true")
        
        return NSFetchedResultsController(fetchRequest: fr, managedObjectContext: self.stack.context, sectionNameKeyPath: nil,cacheName: nil)
    }()
    
    // MARK: Lifecycle methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Error in 'viewAppear' method")
        }
        
        DispatchQueue.main.async {
            self.hasSavedWines()
            self.wineListTableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Error in 'viewDidLoad' method")
        }
        
        // Set nav bar style
        wineRackNavBar.setBarBackgroundColor(UIColor.wineRackDarkRed)
        
        // Hide tableView by default, and only show if we have wines saved
        wineListTableView.isHidden = true
        
        noWinesLabel.text = Constants.NoWinesLabel.WishList
        noWinesLabel.textColor = UIColor.wineRackLightRed
        
        // Register nib
        wineListTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "WineCell")
        
        self.wineListTableView.rowHeight = UITableViewAutomaticDimension
        self.wineListTableView.estimatedRowHeight = 120.00
    }
    
    // MARK: Private methods
    
    func hasSavedWines() {
        if let frc = fetchedResultsController {
            if (frc.fetchedObjects?.count)! > 0 {
                wineListTableView.isHidden = false
                noWinesView.isHidden = true
            } else {
                wineListTableView.isHidden = true
                noWinesView.isHidden = false
                noWinesLabel.text = Constants.NoWinesLabel.WishList
                noWinesLabel.textColor = UIColor.wineRackLightRed
            }
        }
    }
    
    // MARK: Delegate methods
    
    func wineRackIsUpdated() {
        DispatchQueue.main.async {
            self.wineListTableView?.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let frc = fetchedResultsController {
            return (frc.fetchedObjects!.count)
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WineCell") as! SearchTableViewCell
        
        if (fetchedResultsController?.fetchedObjects?.count)! > 0 {
            
            let wine = fetchedResultsController?.object(at: indexPath) as? Wine
            
            cell.nameLabel.text = wine?.name
            cell.typeLabel.text = wine?.wineType
            cell.vintageLabel.text =  wine?.vintage
            cell.infoUrl = wine?.url
            
            if let url = wine?.labelUrl {
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
            
            cell.wineRackButton.isHidden = true
            cell.wishListButton.isHidden = true
        }
        
        return cell
    }

}
