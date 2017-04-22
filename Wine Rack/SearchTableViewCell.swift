//
//  SearchTableViewCell.swift
//  Wine Rack
//
//  Created by David Gibbs on 22/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var labelImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var vintageLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var wineRackButton: UIButton!
    @IBOutlet weak var wishListButton: UIButton!

    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func wineRackButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func wishListButtonPressed(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
