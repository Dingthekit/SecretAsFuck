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
    var checkin_nsdate = NSDate()
    var checkout_nsdate = NSDate()
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
        formatter.dateFormat = "dd MMM, YYYY     EEEE"
        return formatter
    }()
    
    // SuperView IBOutlet
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

        
        self.samplesubview.frame.size = CGSize.init(width: (self.view.superview?.frame.size.width)!, height: (self.view.superview?.frame.size.height)! - 30 * 2)

        //self.samplesubview.center = CGPoint(x: (self.view.superview?.frame.size.width)! / 2, y: (self.view.superview?.frame.size.height)! / 2)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "confirm_date" {
            
            let sb = UIStoryboard( name : "Booknow", bundle : nil )
            
            let sub_vc = sb.instantiateViewController(withIdentifier: "booknow_search") as! booknow_search
            sub_vc.checkin_date = self.checkin_nsdate as Date
            sub_vc.checkout_date = self.checkout_nsdate as Date

            let vc = segue.destination as! UINavigationController
            vc.viewControllers[0] = sub_vc
 

        }
    }
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calender Delegate
        Calender.delegate = self
        Calender.dataSource = self
        calender_setup()
        let dates = [ self.gregorian.date(byAdding: .day, value: 0, to: Date()),
                      self.gregorian.date(byAdding: .day, value: +1, to: Date()) ]
        dates.forEach { (date) in
            self.Calender.select(date, scrollToDate: false)
        }
        self.checkin_nsdate = self.Calender.selectedDates[0] as NSDate
        self.checkout_nsdate = self.Calender.selectedDates.sorted()[self.Calender.selectedDates.count - 1] as NSDate
        
        checkin_date.setTitle(formatter2.string(from: dates[0]!), for: .normal)
        checkout_date.setTitle(formatter2.string(from: dates[1]!), for: .normal)
 
        
    }
    
    func calender_setup(){
        
        self.Calender.scrollDirection = .vertical
        self.Calender.swipeToChooseGesture.isEnabled = true
        //self.Calender.today = nil
        self.Calender.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        
    }
    
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
        self.subview_date.text = "Please select date"
        self.subview_night.text = ""
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
                
                self.checkin_nsdate = self.Calender.selectedDates[0] as NSDate
                self.checkout_nsdate = self.Calender.selectedDates.sorted()[self.Calender.selectedDates.count - 1] as NSDate
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
