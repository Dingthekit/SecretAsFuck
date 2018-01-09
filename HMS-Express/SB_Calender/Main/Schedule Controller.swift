//
//  Schedule Controller.swift
//  HMS-Express
//
//  Created by chia on 1/9/18.
//  Copyright © 2018 Ding Zhan Chia. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase

class Schedule_Controller: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    fileprivate var listofbooking = [ Booking ]()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    @IBOutlet var Schedule_calender: FSCalendar!

    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
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
            //self.Price_calender.deselect(date)
            //self.label_setup(isOn: true)
            
        }
        
        var isBefore = Bool()
        if !self.Schedule_calender.selectedDates.isEmpty && self.Schedule_calender.selectedDates[0] < date {
            isBefore = true
        } else {
            isBefore = false
        }
        
        // loop all the calender and select the things
        for booking in listofbooking {
            var isFound : Bool = false
            
            if isBefore {
                if date == self.formatter.date(from: booking.get_checkindate())! {
                    isFound = true
                }
            }
            
            // Clear all the selected date first
            for selected_date in self.Schedule_calender.selectedDates{
                self.Schedule_calender.deselect(selected_date)
            }
            
            if isFound {
                var start_date = self.formatter.date(from: booking.get_checkindate())!
                let end_date = self.formatter.date(from: booking.get_checkoutdate())!
                self.Schedule_calender.select(start_date)
                while start_date < end_date {
                    start_date = Calendar.current.date(byAdding: .day, value: 1, to: start_date)!
                    self.Schedule_calender.select(start_date)
                }
                
                
                //self.label_setup(isOn: false)
                //self.checkin_date_label.text = booking.get_checkindate()
                //self.checkout_date_label.text = booking.get_checkoutdate()
                //self.Customername_label.text = booking.get_uname()
                
                break
            } else {
                //self.label_setup(isOn: true)
            }
            
        }
        
        
        self.configureVisibleCells()
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            
            // Clear all the selected date first
            for selected_date in self.Schedule_calender.selectedDates{
                self.Schedule_calender.deselect(selected_date)
            }
            
            // loop all the calender and select the things
            for booking in listofbooking {
                var isFound : Bool = false
                if date >= self.formatter.date(from: booking.get_checkindate() )! &&
                    date <= self.formatter.date(from: booking.get_checkoutdate() )! {
                    isFound = true
                }
                
                if isFound {
                    var start_date = self.formatter.date(from: booking.get_checkindate() )!
                    let end_date = self.formatter.date(from: booking.get_checkoutdate() )!
                    self.Schedule_calender.select(start_date)
                    while start_date < end_date {
                        start_date = Calendar.current.date(byAdding: .day, value: 1, to: start_date)!
                        self.Schedule_calender.select(start_date)
                    }
                    
                    // self.checkin_date_label.text = booking.get_checkindate()
                    // self.checkout_date_label.text = booking.get_checkoutdate()
                    // self.Customername_label.text = booking.get_uname()
                    
                    break
                } else{
                   // self.label_setup(isOn: true)
                    
                }
            }

        self.configureVisibleCells()
    }
    
    // Event Delegate
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        var counter : Int = 0
        for booking in self.listofbooking {
            if date >= self.formatter.date(from: booking.get_checkindate() )! &&
                date <= self.formatter.date(from: booking.get_checkoutdate() )! {
                counter += 1
            }
        }
        
        // When no event in found
        return counter
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {

            return [UIColor.orange]
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.Schedule_calender.frame.size.height = bounds.height
        // self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func configureVisibleCells() {
        self.Schedule_calender.visibleCells().forEach { (cell) in
            let date = self.Schedule_calender.date(for: cell)
            let position = self.Schedule_calender.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! PriceCalendarCell)
        
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if self.Schedule_calender.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if self.Schedule_calender.selectedDates.contains(date) {
                    
                    if self.Schedule_calender.selectedDates.contains(previousDate) && self.Schedule_calender.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    } else if self.Schedule_calender.selectedDates.contains(previousDate) && self.Schedule_calender.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    } else if self.Schedule_calender.selectedDates.contains(nextDate) {
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

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
