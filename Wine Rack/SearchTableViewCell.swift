//
//  SearchTableViewCell.swift
//  Wine Rack
//
//  Created by David Gibbs on 22/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var labelImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var vintageLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var wineRackButton: UIButton!
    @IBOutlet weak var wishListButton: UIButton!
    
    // MARK: IBActions
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        if let url = infoUrl {
            let validUrl = URL(string: url)
            
            if UIApplication.shared.canOpenURL(validUrl!) {
                UIApplication.shared.open(validUrl!, options: [:], completionHandler: nil)
            } else {
                print("CANNOT OPEN URL")
            }
        } else {
            print("INFO URL WASN'T VALID")
        }
    }
    
    @IBAction func wineRackButtonPressed(_ sender: UIButton) {
        // TODO: Add to winerack popup
    }
    
    @IBAction func wishListButtonPressed(_ sender: UIButton) {
        // TODO: Add to wishlist popup
    }
    
    // MARK: Variables/Constants
    
    var infoUrl: String?
    var labelImageUrl: String?
    let stack = CoreDataStack.sharedInstance()
    
    // MARK: Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        configureUI()
    }
    
    // MARK: Private methods
    
    func configureUI() {
        labelImageView.layer.cornerRadius = 3
        
        infoButton.backgroundColor = UIColor.white
        infoButton.layer.cornerRadius = 3;
        infoButton.layer.borderWidth = 1;
        infoButton.layer.borderColor = UIColor.wineRackLightGrey.cgColor
        infoButton.setTitleColor(UIColor.wineRackLightGrey, for: .normal)
        
        wineRackButton.backgroundColor = UIColor.wineRackDarkRed
        wineRackButton.layer.cornerRadius = 3
        
        wishListButton.backgroundColor = UIColor.wineRackLightRed
        wishListButton.layer.cornerRadius = 3
    }
    
    func downloadImage( imageUrl:String, completionHandler: @escaping (_ imageData: Data?, _ errorString: String?) -> Void){
        let session = URLSession.shared
        let imgURL = URL(string: imageUrl)
        let request = URLRequest(url: imgURL!)
        
        let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
            if downloadError != nil {
                completionHandler(nil, "Could not download image \(imageUrl)")
            } else {
                completionHandler(data, nil)
            }
        }
        
        task.resume()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // TODO: Configure the view for the selected state
    }
    
}
