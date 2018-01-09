//
//  Price_Controller.swift
//  HMS-Express
//
//  Created by chia on 1/9/18.
//  Copyright © 2018 Ding Zhan Chia. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase

class Price_Controller: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    // Variable
    var listofprice = [ String : String ]()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    // IBOutlet
    @IBOutlet var Price_calender: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func load_price() {
        //observing the data changes
        
        let ref_Homestay = Database.database().reference().child("Homestay").child(self.company_id).child(self.homestay_id).child("Price")
        
        ref_Homestay.observeSingleEvent(of: DataEventType.value , with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                // Clearing the list
                self.listofprice.removeAll()
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    let date = snap.key
                    let price = snap.value as! String
                    self.listofprice[date] = price
                }
            }
        })
    }*/
    
    // Calender Delegate
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date < calendar.today! {
            return UIColor.lightGray
        } else {
            return UIColor.init(red: 35/255, green: 59/255, blue: 77/255, alpha: 1)
        }
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "price_cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        if !(date < calendar.today!) {
            self.Price_calender.deselect(date)
        }

        self.configureVisibleCells()
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if date < calendar.today! {
            self.Price_calender.deselect(date)
        } else {
            self.Price_calender.select(date)
        }
       
        self.configureVisibleCells()
    }
    
    // Event Delegate
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
            return nil
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.Price_calender.frame.size.height = bounds.height
        // self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func configureVisibleCells() {
        self.Price_calender.visibleCells().forEach { (cell) in
            let date = self.Price_calender.date(for: cell)
            let position = self.Price_calender.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! PriceCalendarCell)
        
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if self.Price_calender.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if self.Price_calender.selectedDates.contains(date) {
                    
                    if self.Price_calender.selectedDates.contains(previousDate) && self.Price_calender.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    } else if self.Price_calender.selectedDates.contains(previousDate) && self.Price_calender.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    } else if self.Price_calender.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    } else {
                        selectionType = .single
                    }
                }
            } else {
                selectionType = .none
            }
            
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            diyCell.selectionLayer.isHidden = true
        }
    } // function end
    
}
