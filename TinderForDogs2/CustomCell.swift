//
//  CustomCell.swift
//  TinderForDogs2
//
//  Created by Amanda Demetrio on 9/27/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var smallImageView: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    
    @IBAction func emailButtonClicked(_ sender: UIButton) {
        print("email button was clicked")
    }
    
    @IBAction func callButtonClicked(_ sender: UIButton) {
        print("call button was clicked")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
