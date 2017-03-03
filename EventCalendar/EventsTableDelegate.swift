//
//  EventsTableDelegate.swift
//  CalenderTesting
//
//  Created by Thomas Martin on 3/1/17.
//  Copyright © 2017 Thomas Martin. All rights reserved.
//

import Foundation
import UIKit

class EventsTableDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    var eventsArr: [Event] = []
    var tableview: UITableView?
    var primaryColor: UIColor?
    
    init(eventsArr: [Event], tableView: UITableView, primaryColor: UIColor) {
        self.tableview = tableView
        self.eventsArr = eventsArr
        self.primaryColor = primaryColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("The number of rows is \(eventsArr.count)")
        //return eventsArr.count
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return eventsArr.count
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventCell = tableview!.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        cell.colorView.backgroundColor = primaryColor
        cell.label.text = eventsArr[indexPath.section].title
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 5.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
}
