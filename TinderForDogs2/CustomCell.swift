//
//  CustomCell.swift
//  TinderForDogs2
//
//  Created by Amanda Demetrio on 9/27/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import UIKit

protocol CustomCellDelegate {
    func sendEmailButtonClick(_ indexPath: IndexPath)
    func sendCallButtonClick(_ indexPath: IndexPath)
}

class CustomCell: UITableViewCell {
    
    var delegate: CustomCellDelegate?
    
    var indexPath: IndexPath?
    
    @IBOutlet weak var smallImageView: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    
    @IBAction func emailButtonClicked(_ sender: UIButton) {
        delegate?.sendEmailButtonClick(indexPath!)
    }
    
    @IBAction func callButtonClicked(_ sender: UIButton) {
        delegate?.sendCallButtonClick(indexPath!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
