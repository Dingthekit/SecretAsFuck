//
//  Booknow_main+Calender.swift
//  HMS-Express
//
//  Created by Ding Zhan on 29/12/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import FSCalendar

extension booknow_main {

    // MARK : Calender Delegate
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date < calendar.today! {
            return UIColor.lightGray
        } else {
            return UIColor.init(red: 35/255, green: 59/255, blue: 77/255, alpha: 1)
        }
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        
        for selected_date in self.Calender.selectedDates{
            self.Calender.deselect(selected_date)
        }
        
        self.configureVisibleCells()
        
        self.sub_checkin_day.text = "Please Select Date"
        self.sub_checkin_date.text = " "
        self.sub_checkout_day.text = " "
        self.sub_checkout_date.text = ""
        
        self.done_button.backgroundColor?.withAlphaComponent(0.5)
        self.done_button.isEnabled = false
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if date < calendar.today! {
            self.Calender.deselect(date)
        }
        
        // Reset Data When User Clicked Again
        if (self.Calender.selectedDates.count > 2 ) {
            
            for selected_date in self.Calender.selectedDates{
                self.Calender.deselect(selected_date)
            }
            
            self.Calender.select(date)
            self.sub_checkin_day.text = self.sub_formatter_day.string(from: self.Calender.selectedDates[0])
            self.sub_checkin_date.text = self.sub_formatter_date.string(from: self.Calender.selectedDates[0])
            self.sub_checkout_day.text = "Please Select Date"
            self.sub_checkout_date.text = " "
            
            self.done_button.backgroundColor?.withAlphaComponent(0.5)
            self.done_button.isEnabled = false
        }
            
        // When Check Out Date is Selected
        else if (self.Calender.selectedDates.count == 2 ) {
            
            // Second Date is earlier than previous chosen Date
            if (self.Calender.selectedDates[0] > self.Calender.selectedDates[1]){
                
                self.Calender.deselect(self.Calender.selectedDates[0])
                self.sub_checkin_day.text = self.sub_formatter_day.string(from: self.Calender.selectedDates[0])
                self.sub_checkin_date.text = self.sub_formatter_date.string(from: self.Calender.selectedDates[0])
                self.sub_checkout_day.text = "Please Select Date"
                self.sub_checkout_date.text = " "
                
                // Button Setup
                self.done_button.backgroundColor?.withAlphaComponent(0.5)
                self.done_button.isEnabled = false
                
            }
                
            // Select The Range of the Date
            else {
                var currentDate = self.Calender.selectedDates[0]
                let calendarEndDate = date
                while(currentDate < calendarEndDate) {
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                    self.Calender.select(currentDate)
                }
                
                self.sub_checkin_day.text = self.sub_formatter_day.string(from: self.Calender.selectedDates[0])
                self.sub_checkin_date.text = self.sub_formatter_date.string(from: self.Calender.selectedDates[0])
                self.sub_checkout_day.text = self.sub_formatter_day.string(from: self.Calender.selectedDates.sorted().last!)
                self.sub_checkout_date.text = self.sub_formatter_date.string(from: self.Calender.selectedDates.sorted().last!)

                self.done_button.backgroundColor?.withAlphaComponent(1)
                self.done_button.isEnabled = true
                
            }
        } else {
            self.sub_checkin_day.text = "Please Select Date"
            self.sub_checkin_date.text = " "
            self.sub_checkout_day.text = " "
            self.sub_checkout_date.text = " "
        }
        self.configureVisibleCells()
    }
    
    func configureVisibleCells() {
        self.Calender.visibleCells().forEach { (cell) in
            let date = self.Calender.date(for: cell)
            let position = self.Calender.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! DIYCalendarCell)
        
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if self.Calender.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if self.Calender.selectedDates.contains(date) {
                    
                    if self.Calender.selectedDates.contains(previousDate) && self.Calender.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    } else if self.Calender.selectedDates.contains(previousDate) && self.Calender.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    } else if self.Calender.selectedDates.contains(nextDate) {
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
