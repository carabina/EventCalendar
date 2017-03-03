//
//  ScrollAndReplaceViewController.swift
//  CalenderTesting
//
//  Created by Thomas Martin on 1/17/17.
//  Copyright © 2017 Thomas Martin. All rights reserved.
//

import UIKit

class ScrollAndReplaceViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var scrollView: UIScrollView!
    private var currentMonth = 0
    private var currentYear = 0
    private var currentScrollPos = 1
    private let controllers = NSMutableArray(capacity: 0)
    private var controllersArr:[UIViewController] = [UIViewController(), UIViewController(), UIViewController()]
    private var screenCount = 0
    private var firstTime = true
    private var EventArr:[Event] = []
    private var hasMonthLabel: Bool? = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let calendar = Calendar.current
        //let date = Date()
        //let date2 = calendar.date(from: DateComponents(calendar: calendar, year: 2017, month: 2, day: 25, hour: 10))
        //addEvent(title: "Event 1", date: date)
        //addEvent(title: "Event 2", date: date2!)
        //addEvent(title: "Event 3", date: date2!)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if firstTime {
            firstTime = false
            setup()
        }
    }
    
    func setup () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 3 * screenWidth, height: screenHeight)
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponentsMonth = myCalendar.components(.month, from: Date())
        let myComponentsYear = myCalendar.components(.year, from: Date())
        
        let month = myComponentsMonth.month
        currentMonth = month!
        let year = myComponentsYear.year
        currentYear = year!
        
        print("the month is \(month)")
        
        let startNum: Int = month! - 1
        let endNum: Int = month! + 1
        var count = 0
        
        for i in startNum...endNum {
            let calendar = Calendar.current
            
            var monthStart = Date()
            if i <= 0 {
                monthStart = DateComponents(calendar: calendar, year: year! - 1, month: i).date!
            } else {
                monthStart = DateComponents(calendar: calendar, year: year, month: i).date!
            }
            
            let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart)
            
            var monthsEvents: [Event] = []
            
            for event in EventArr {
                if  (event.date! == monthStart || event.date! > monthStart) && event.date! < monthEnd! {
                    monthsEvents.append(event)
                }
            }
            
            let first: CollectionViewController = storyboard.instantiateViewController(withIdentifier: "monthVC") as! CollectionViewController
            first.eventsArr = monthsEvents
            
            first.showMonthLabel = hasMonthLabel!
            //first.removeMonthLabel()
            scrollView.addSubview((first.view)!)
            first.view.frame = CGRect(x: screenWidth*(CGFloat(count)), y: 0, width: screenWidth, height: screenHeight)
            
            controllers.add(first)
            self.addChildViewController(first)
            
            if i <= 0 {
                print("month \(12-i)")
                first.initMonth(month: 12+i, year: year!-1)
            } else {
                print("month \(i)")
                first.initMonth(month: i, year: year!)
            }
            
            controllersArr[count] = first
            count += 1
            screenCount+=1
        }
        
        scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0.0), animated: false)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let xPos = scrollView.contentOffset.x+10
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if currentScrollPos != Int(xPos/width) {
            if currentScrollPos < Int(xPos/width) {
                currentMonth += 1
                
                if currentMonth == 13 {
                    currentMonth = 1
                    currentYear += 1
                }
                
                controllersArr[0].view.removeFromSuperview()
                controllersArr[1].view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                controllersArr[2].view.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
                controllersArr[0] = controllersArr[1]
                controllersArr[1] = controllersArr[2]
                
                if currentMonth+1 < 13 {
                    controllersArr[2] = addMonth(month: currentMonth+1, year: currentYear, position: 2)
                } else {
                    controllersArr[2] = addMonth(month: 1, year: currentYear+1, position: 2)
                }
                scrollView.layoutIfNeeded()
                scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0.0), animated: false)
            } else {
                currentMonth -= 1
                
                if currentMonth == 0 {
                    currentMonth = 12
                    currentYear -= 1
                }
                
                controllersArr[2].view.removeFromSuperview()
                controllersArr[1].view.frame = CGRect(x: 2*screenWidth, y: 0, width: screenWidth, height: screenHeight)
                controllersArr[0].view.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
                controllersArr[2] = controllersArr[1]
                controllersArr[1] = controllersArr[0]
                
                if currentMonth-1 > 0 {
                    controllersArr[0] = addMonth(month: currentMonth-1, year: currentYear, position: 0)
                } else {
                    controllersArr[0] = addMonth(month: 12, year: currentYear-1, position: 0)
                }
                scrollView.layoutIfNeeded()
                scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0.0), animated: false)

            }
            
            //scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0.0), animated: false)
        }
        
        print("The current position is \(currentScrollPos)")
    }
    
    func addMonth(month: Int, year: Int, position: Int) -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let calendar = Calendar.current
        let monthStart = DateComponents(calendar: calendar, year: year, month: month).date
        let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart!)
        
        var monthsEvents: [Event] = []
        
        for event in EventArr {
            if  (event.date! == monthStart || event.date! > monthStart!) && event.date! < monthEnd! {
                monthsEvents.append(event)
            }
        }
        
        let first: CollectionViewController = storyboard.instantiateViewController(withIdentifier: "monthVC") as! CollectionViewController
        first.eventsArr = monthsEvents
        
        first.showMonthLabel = hasMonthLabel!
        scrollView.addSubview((first.view)!)
        first.view.frame = CGRect(x: screenWidth*(CGFloat(position)), y: 0, width: screenWidth, height: screenHeight)
        
        controllers.removeObject(at: position)
        controllers.insert(first, at: position)
        self.addChildViewController(first)
  
        first.initMonth(month: month, year: year)
        
        return first
    }
    
    func addEvent(title: String, date: Date) {
        let event: Event = Event(date: date, title: title)
        EventArr.append(event)
        EventArr = EventArr.sorted(by: {$0.date! > $1.date!})
    }
    
    func removeMonthYearLabel() {
        hasMonthLabel = false
    }
    
    func getcurrentMonthYear() -> String {
        return ""
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
