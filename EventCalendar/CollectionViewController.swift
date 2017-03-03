//
//  CollectionViewController.swift
//  CalenderTesting
//
//  Created by Thomas Martin on 1/1/17.
//  Copyright © 2017 Thomas Martin. All rights reserved.
//

import UIKit

enum Style {
    case classic
    case fun
}

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    //@IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var eventsTable: UITableView!
    
    var daysInMonth = 31
    var startWeekday = 1
    var currentStyle: Style = Style.fun
    var primaryColor: UIColor = UIColor(red: 26/256, green: 35/256, blue: 126/256, alpha: 1.0)
    var secondaryColor: UIColor = UIColor(red: 197/256, green: 202/256, blue: 233/256, alpha: 1.0)
    var showMonthLabel: Bool = true
    var selectedCellView: UIView?
    var monthString: String?
    var month: Int?
    var yearString: String?
    var year: Int?
    var eventsArr: [Event] = []
    var cellArr: [Int: DayCollectionViewCell] = [:]
    var tableViewDelegate: EventsTableDelegate?
    var today: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //eventsLabel.isHidden = true
        eventsTable.isHidden = true
        
        tableViewDelegate = EventsTableDelegate(eventsArr: [], tableView: eventsTable, primaryColor: primaryColor)
        eventsTable.delegate = tableViewDelegate
        eventsTable.dataSource = tableViewDelegate
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        if !showMonthLabel {
            
            let topConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            self.view.addConstraint(topConstraint)
            monthLabel.removeFromSuperview()
        } else {
            let topConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: monthLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            self.view.addConstraint(topConstraint)
        }
        
        if currentStyle == Style.fun {
            collectionView.backgroundColor = secondaryColor
            self.view.backgroundColor = secondaryColor
            eventsTable.backgroundColor = secondaryColor
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let screenSize: CGRect = UIScreen.main.bounds
        let dayWidth = (screenSize.width - 100)/7.0
        
        if dayWidth > 42 {
            monthLabel.font = monthLabel.font.withSize(19)
        } else if dayWidth < 35 {
            monthLabel.font = monthLabel.font.withSize(14)
        }
    }
    
    func initMonth(month: Int, year: Int) {
        daysInMonth = getDaysInMonth(month: month, year: year)
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        monthLabel.text = "\(months[month - 1]) \(year)"
        monthString = "\(months[month - 1])"
        self.month = month
        self.year = year
        yearString = "\(year)"
        
        if month < 10 {
            startWeekday = getDayOfWeek(today: "\(year)-0\(month)-01")
        } else {
            startWeekday = getDayOfWeek(today: "\(year)-\(month)-01")
        }
    }
    
    func getDayOfWeek(today:String)->Int {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        return weekDay!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (8 + daysInMonth + startWeekday - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < 7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            
            let screenSize: CGRect = UIScreen.main.bounds
            let dayWidth = (screenSize.width - 100)/7.0
            
            if dayWidth > 42 {
                cell.dayLabel.font = cell.dayLabel.font.withSize(19)
            } else if dayWidth < 35 {
                print("In here")
                cell.dayLabel.font = cell.dayLabel.font.withSize(14)
            }
        
            let week = ["S", "M", "T", "W", "T", "F", "S"]
            cell.dayLabel.text = week[indexPath.row]
        
            return cell
        } else if indexPath.row == 7 {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            
            cell.dayLabel.text = ""
            cell.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daycell", for: indexPath) as! DayCollectionViewCell
            
            let screenSize: CGRect = UIScreen.main.bounds
            let dayWidth = (screenSize.width - 100)/7.0
            
            if dayWidth > 42 {
                cell.dayNum.font = cell.dayNum.font.withSize(22)
            } else if dayWidth < 35 {
                print("In here")
                cell.dayNum.font = cell.dayNum.font.withSize(14)
            }
            
            let day = indexPath.row - 6 - startWeekday
            
            if day < 1 {
               cell.dayNum.text = ""
            } else {
                cell.dayNum.text = "\(day)"
            }
            
            switch currentStyle {
                case Style.fun:
                    cell.backgroundColor = primaryColor
                    cell.dayNum.textColor = UIColor.white
                    cell.layer.masksToBounds = true
                    cell.layer.cornerRadius = 6
      
                    if cell.dayNum.text == "" {
                        cell.backgroundColor = primaryColor.withAlphaComponent(0.5)
                    } else {
                        // Look here! So for these cells we need to add a date array
                        let calendar = Calendar.current
                        let cellDate = calendar.date(from: DateComponents(calendar: calendar, year: year, month: month, day: day))
                        
                        let dayEvents = eventsArr.filter{ $0.dateNoTime == cellDate }
                        cell.eventsArr = dayEvents
                        
                        cell.layer.shadowColor = UIColor.black.cgColor
                        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                        cell.layer.shadowRadius = 2.0
                        cell.layer.shadowOpacity = 1.0
                        cell.layer.masksToBounds = false
                        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
                        
                        cell.tag = day
                        let tapRecognizer = UITapGestureRecognizer(target: self, action:  #selector (self.selectDay (_:)))
                        cell.addGestureRecognizer(tapRecognizer)
                        cellArr[day] = cell
                        
                        if dayEvents.count != 0 {
                            print(dayEvents)
                            
                            let circlePath = UIBezierPath(arcCenter: CGPoint(x: cell.frame.width/2,y: cell.frame.height*2/3), radius: CGFloat(3), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
                        
                            let shapeLayer = CAShapeLayer()
                            shapeLayer.path = circlePath.cgPath
                    
                            //change the fill color
                            shapeLayer.fillColor = UIColor.white.cgColor
                            //you can change the stroke color
                            shapeLayer.strokeColor = UIColor.white.cgColor
                            //you can change the line width
                            shapeLayer.lineWidth = 3.0
                            cell.layer.addSublayer(shapeLayer)
                        }

                    }
                
                    break
                
                default: break
            }
            
            let today = Date()
            let calendar = Calendar.current
            
            let currentYear = calendar.component(.year, from: today)
            let currentMonth = calendar.component(.month, from: today)
            let currentDay = calendar.component(.day, from: today)
            
            
            let label: [String] = (monthLabel.text?.components(separatedBy: " "))!
            let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
            
            
            if day == currentDay && months[currentMonth-1] == label[0] && "\(currentYear)" == label[1] {
                self.today = currentDay
                
                switch currentStyle {
                    case Style.fun:
                        cell.backgroundColor = UIColor(red: 198/256, green: 40/256, blue: 40/256, alpha: 1.0)
                        break
                    
                    case Style.classic:
                        cell.dayNum.layer.masksToBounds = true
                        cell.dayNum.layer.cornerRadius = cell.dayNum.frame.height/2.0
                        cell.dayNum.backgroundColor = UIColor.red
                        break
                    
                    //default: break
                    
                }
                
                /*cell.dayNum.textColor = UIColor.white
                cell.dayNum.layer.masksToBounds = true
                cell.dayNum.layer.cornerRadius = cell.dayNum.frame.height/2.0
                cell.dayNum.backgroundColor = UIColor.red
                
                // Comment
                cell.circle.layer.masksToBounds = true
                print(cell.circle.frame.width)
                cell.circle.layer.cornerRadius = 8//cell.circle.frame.height/2.0
                cell.circle.backgroundColor = UIColor.lightGray*/

            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath: IndexPath) -> CGSize {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let dayWidth = (screenSize.width - 100)/7.0
        //print("The day width is \(dayWidth)")
    
        
        if sizeForItemAtIndexPath.row < 7 {
            return CGSize(width: dayWidth, height: 30.0)
        } else if sizeForItemAtIndexPath.row > 7 {
            return CGSize(width: dayWidth, height: dayWidth + dayWidth/2.0)
        } else {
            return CGSize(width: screenSize.width, height: 1)
        }
    }
    
    func getDaysInMonth(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    func selectDay(_ sender:UITapGestureRecognizer){
        if selectedCellView != nil {
            if selectedCellView?.tag == today {
                selectedCellView?.backgroundColor = UIColor(red: 198/256, green: 40/256, blue: 40/256, alpha: 1.0)
            } else {
                selectedCellView?.backgroundColor = primaryColor.withAlphaComponent(1.0)
            }
            sender.view?.layer.shadowOpacity = 1.0
            
        }

        let day: Int = (sender.view?.tag)!
        
        if today == day {
            sender.view?.backgroundColor = UIColor(red: 198/256, green: 40/256, blue: 40/256, alpha: 0.75)
        } else {
            sender.view?.backgroundColor = primaryColor.withAlphaComponent(0.5)
        }
        
        sender.view?.layer.shadowOpacity = 0.5
        selectedCellView = sender.view
        
        
        let heightConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: collectionView.contentSize.height + 4)
        collectionView.addConstraint(heightConstraint)
        
        self.view.layoutIfNeeded()
        
        tableViewDelegate?.eventsArr = (cellArr[day]?.eventsArr)!
        eventsTable.reloadData()
        //eventsLabel.text = "\(monthString!) \(day), \(yearString!)"
        //eventsLabel.isHidden = false
        eventsTable.isHidden = false
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
