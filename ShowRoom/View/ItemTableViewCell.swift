//
//  ItemsTableViewCell.swift
//  ShowRoom
//
//  Created by Oleksandr Buravlyov on 4/8/18.
//  Copyright © 2018 farelapps. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
    
    func setTitle(_ title: String) {
        textLabel?.text = title
        activityIndicator.stopAnimating()
    }
    
    override func prepareForReuse() {
        textLabel?.text = nil
        accessoryType = .none
        activityIndicator.startAnimating()
    }
    
}
