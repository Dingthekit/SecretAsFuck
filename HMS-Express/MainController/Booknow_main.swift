//
//  booknow_main.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import FSCalendar

class booknow_main: UIViewController, UITextFieldDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    // Subview IBOutlet
    @IBOutlet weak var subview_date: UILabel!
    @IBOutlet weak var done_button: UIButton!
    @IBOutlet weak var subview_night: UILabel!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "  d MMM ( EEE )"
        return formatter
    }()
    fileprivate let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, YYYY"
        return formatter
    }()
    
    // SuperView IBOutlet
    @IBOutlet var adult_uitext: UITextField!
    @IBOutlet var children_uitext: UITextField!
    @IBOutlet var samplesubview: UIView!
    @IBOutlet var Calender: FSCalendar!
    @IBOutlet var checkin_date: UIButton!
    @IBOutlet var checkout_date: UIButton!

    // IBAction
    @IBAction func to_subview(_ sender: UIButton) {
        
        // Subview Setup
        self.done_button.backgroundColor?.withAlphaComponent(0.5)
        self.done_button.isEnabled = false
        
        let blurEffect = UIBlurEffect(style: .dark )
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.view.insertSubview(blurEffectView, at: 0)
        self.samplesubview.center = CGPoint(x: (self.view.superview?.frame.size.width)! / 2, y: (self.view.superview?.frame.size.height)! / 2)
        self.view.addSubview(self.samplesubview)
        
        // Turn off button
        samplesubview.isHidden = false
        self.subview_date.text = "Please select date"
        self.subview_night.text = ""

        // Hide Tab Bar
        self.tabBarController?.tabBar.isHidden = true


    }
    
    @IBAction func back_subview(_ sender: UIButton) {
        
        // Hide All Subviews
        samplesubview.isHidden = true
        self.tabBarController?.tabBar.isHidden = false

        // Update the Button
        self.checkin_date.setTitle(formatter2.string(from: self.Calender.selectedDates[0]), for: .normal)
        self.checkout_date.setTitle(formatter2.string(from: self.Calender.selectedDates.sorted()[self.Calender.selectedDates.count - 1]), for: .normal)
        
    }
    
    @IBAction func AddAction_adult(_ sender: UIButton){
            var adult_pax : Int = Int(adult_uitext.text!)!
            adult_pax += 1
            adult_uitext.text = String(adult_pax)
    }
    
    @IBAction func MinusAction_adult(_ sender: UIButton) {
            var adult_pax : Int = Int(adult_uitext.text!)!
            if adult_pax == 0 { adult_pax = 0 }
            else{ adult_pax -= 1 }
            adult_uitext.text = String(adult_pax)
    }
    
    @IBAction func AddAction_child(_ sender: UIButton) {
            var child_pax : Int = Int(children_uitext.text!)!
            child_pax += 1
            children_uitext.text = String(child_pax)
    }
    
    @IBAction func MinusAction_child(_ sender: UIButton) {
            var child_pax : Int = Int(children_uitext.text!)!
            if child_pax == 0 { child_pax = 0 }
            else{ child_pax -= 1 }
            children_uitext.text = String(child_pax)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as UIViewController
        vc.navigationItem.title = "Back"
    }
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calender Delegate
        Calender.delegate = self
        Calender.dataSource = self
        calender_setup()
        let dates = [ self.gregorian.date(byAdding: .day, value: -1, to: Date()),
                      self.gregorian.date(byAdding: .day, value: 0, to: Date()) ]
        dates.forEach { (date) in
            self.Calender.select(date, scrollToDate: false)
        }
        
        // Default All Valye
        checkin_date.setTitle(formatter2.string(from: dates[0]!), for: .normal)
        checkout_date.setTitle(formatter2.string(from: dates[1]!), for: .normal)
        adult_uitext.text = "0"
        children_uitext.text = "0"
        
    }
    
    func calender_setup(){
        
        self.Calender.scrollDirection = .vertical
        self.Calender.swipeToChooseGesture.isEnabled = true
        self.Calender.today = nil
        self.Calender.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    // MARK : Calender Delegate
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
        self.subview_date.text = "Please select date"
        self.subview_night.text = ""
        self.done_button.backgroundColor?.withAlphaComponent(0.5)
        self.done_button.isEnabled = false

    }
    
     func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    
        // Reset Data When User Clicked Again
        if (self.Calender.selectedDates.count > 2 ) {
            
            for selected_date in self.Calender.selectedDates{
                self.Calender.deselect(selected_date)
            }
            
            self.Calender.select(date)
            self.subview_date.text = "Please select date"
            self.subview_night.text = ""
            
            self.done_button.backgroundColor?.withAlphaComponent(0.5)
            self.done_button.isEnabled = false
        }
        
        // When Check Out Date is Selected
        else if (self.Calender.selectedDates.count == 2 ) {
            
            // Second Date is earlier than previous chosen Date
            if (self.Calender.selectedDates[0] > self.Calender.selectedDates[1]){
                
                self.Calender.deselect(self.Calender.selectedDates[0])
                self.subview_date.text = "Please select date"
                self.subview_night.text = ""

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
                
                let start_day : String = self.formatter.string(from: self.Calender.selectedDates[0])
                let end_day : String = self.formatter.string(from: self.Calender.selectedDates.sorted().last!)
                self.subview_date.text = start_day + " - " + end_day
                if (self.Calender.selectedDates.count == 2){
                    self.subview_night.text = String(self.Calender.selectedDates.count - 1) + " Night"
                } else {
                    self.subview_night.text = String(self.Calender.selectedDates.count - 1) + " Nights"
                }

                self.done_button.backgroundColor?.withAlphaComponent(1)
                self.done_button.isEnabled = true

            }
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
