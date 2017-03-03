//
//  DayCollectionViewCell.swift
//  CalenderTesting
//
//  Created by Thomas Martin on 1/1/17.
//  Copyright © 2017 Thomas Martin. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayNum: UILabel!
    
    @IBOutlet weak var circle: UILabel!
    
    var eventsArr: [Event]?
}
