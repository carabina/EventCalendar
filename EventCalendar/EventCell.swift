//
//  EventCell.swift
//  CalenderTesting
//
//  Created by Thomas Martin on 3/1/17.
//  Copyright © 2017 Thomas Martin. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        colorView.layer.cornerRadius = 6
        colorView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
