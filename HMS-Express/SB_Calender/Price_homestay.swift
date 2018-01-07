//
//  Price_homestay.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 14/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//
import Foundation
import UIKit
import FSCalendar
import Firebase

class Price_homestay: UIViewController, UITextFieldDelegate ,FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance  {

    // File
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    var listofprice = [ String : String ]()
    var listofbooking = [ Booking ]()

    var company_id = String()
    var homestay_id = String()
    var homestay_name = String()

    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // IBOutlet
    @IBOutlet var Price_calender: FSCalendar!
    @IBOutlet weak var edit_button: ToggleButton!
    @IBOutlet var Calender_segmented: UISegmentedControl!
    
    
    @IBOutlet weak var arrival_label: UILabel!
    @IBOutlet weak var departure_label: UILabel!
    @IBOutlet weak var Customer_label: UILabel!

    @IBOutlet weak var checkin_date_label: UILabel!
    @IBOutlet weak var checkout_date_label: UILabel!
    @IBOutlet weak var Customername_label: UILabel!

    
    @IBOutlet var main_view: UIView!
    @IBOutlet var info_view: UIView!
    @IBOutlet var scroll_view: UIScrollView!
    
    @IBAction func toggle_type(_ sender: UISegmentedControl) {
        if self.Calender_segmented.selectedSegmentIndex == 0 {
            self.edit_button.isHidden = false
            self.edit_button.isOn = false
            self.Price_calender.allowsSelection = false
            self.Price_calender.allowsMultipleSelection = false
            
            for selected_date in self.Price_calender.selectedDates {
                self.Price_calender.deselect(selected_date)
            }
            
            self.label_setup(isOn: true)
            
        } else if self.Calender_segmented.selectedSegmentIndex == 1 {
            self.label_setup(isOn: true)

            self.edit_button.isHidden = true
            self.Price_calender.allowsSelection = true
            self.Price_calender.allowsMultipleSelection = true
        }  else  {
            
            self.info_view.fs_width = (self.view.superview?.fs_width)!
            self.scroll_view.addSubview(info_view)
            self.scroll_view.contentSize = self.info_view.frame.size;
        }
        self.Price_calender.reloadData()
        
    }
    
    // IBAction
    @IBAction func Back_controller(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard( name : "MainController", bundle : nil )
        let vc = sb.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 2
        self.present(vc, animated: true, completion: nil)
    }
    // IBAction
    @IBAction func isEdit(_ sender: ToggleButton) {
        self.Price_calender.allowsSelection = !sender.isOn
        self.Price_calender.allowsMultipleSelection = !sender.isOn

        // End Editing
        if sender.isOn {

            // BC : AlertBox return Nothing
            if self.Price_calender.selectedDates.isEmpty {
                sender.NameOfButton =  "Edit"
            } else {
                
                sender.NameOfButton =  "Edit"
                
                // AlertController
                let alertController = UIAlertController(title: "", message: "Price for selected date", preferredStyle: .alert)
                
                // Add TextField
                alertController.addTextField {
                    $0.placeholder = "Price"
                    $0.addTarget(alertController, action: #selector(alertController.textDidChangeInLoginAlert), for: .editingChanged)
                }

                // confirmAction
                let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
                    
                    guard let price_input = alertController.textFields![0].text else { return }
                    
                    for date in self.Price_calender.selectedDates{
                        self.Price_calender.deselect(date)
                        self.listofprice[self.formatter.string(from: date)] = price_input
                    }
                    
                    sender.NameOfButton = "Edit"
                    
                    let ref = Database.database().reference().child("Homestay").child(self.company_id).child(self.homestay_id)
                    ref.child("Price").setValue(self.listofprice)
                    
                    self.Price_calender.reloadData()


                })
                
                // Cancel Action
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                 
                    sender.NameOfButton = "Edit"
                    for date in self.Price_calender.selectedDates{
                        self.Price_calender.deselect(date)
                    }
                    self.Price_calender.reloadData()
                })
                
                confirmAction.isEnabled = false
                alertController.addAction(cancelAction)
                alertController.addAction(confirmAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
            
        // Start Editing
        else { sender.NameOfButton = "Done" }
        
        self.Price_calender.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.homestay_name

        // Hide All Subviews
        self.navigationController?.navigationBar.barStyle = .blackTranslucent

        print("run")

        // Calender Delegate
        Price_calender.delegate = self
        Price_calender.dataSource = self
        self.Price_calender.register(PriceCalendarCell.self, forCellReuseIdentifier: "price_cell")
        calender_setup()
        label_setup(isOn: true)

        edit_button.initButton("Edit")
        edit_button.activateButton(bool: false)
        
        self.load_price()
        self.load_booking()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.Price_calender.reloadData()
            self.Price_calender.configureAppearance()
        }

        
    }

    func textFieldDidBeginEditing( _ textField: UITextField ) {
        textField.useUnderLine_whileediting()
    }
    
    func textFieldDidEndEditing( _ textField: UITextField) {
        textField.useUnderLine()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func calender_setup(){
        self.Price_calender.scrollDirection = .vertical
        self.Price_calender.swipeToChooseGesture.isEnabled = true
    }
    
    func label_setup( isOn : Bool){
        self.arrival_label.isHidden = isOn
        self.departure_label.isHidden = isOn
        self.Customer_label.isHidden = isOn
        
        self.checkin_date_label.isHidden = isOn
        self.checkout_date_label.isHidden = isOn
        self.Customername_label.isHidden = isOn

    }
    
    
    // MARK : Calender Delegate
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if self.Calender_segmented.selectedSegmentIndex == 0 {
            for item in listofprice {
                if (self.formatter.date(from: item.key)!) == date {
                    return "$ " + String(item.value)
                }
            }
            return "-"
        } else {
            return nil
        }
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
        if self.Calender_segmented.selectedSegmentIndex == 0 {
            if !(date < calendar.today!) {
                self.Price_calender.deselect(date)
            }
        } else {
            if !(date < calendar.today!) {
                self.Price_calender.deselect(date)
                self.label_setup(isOn: true)

            }

            var isBefore = Bool()
            if !self.Price_calender.selectedDates.isEmpty && self.Price_calender.selectedDates[0] < date {
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
                for selected_date in self.Price_calender.selectedDates{
                    self.Price_calender.deselect(selected_date)
                }

                if isFound {
                    var start_date = self.formatter.date(from: booking.get_checkindate())!
                    let end_date = self.formatter.date(from: booking.get_checkoutdate())!
                    self.Price_calender.select(start_date)
                    while start_date < end_date {
                        start_date = Calendar.current.date(byAdding: .day, value: 1, to: start_date)!
                        self.Price_calender.select(start_date)
                    }
                    
                    self.label_setup(isOn: false)
                    self.checkin_date_label.text = booking.get_checkindate()
                    self.checkout_date_label.text = booking.get_checkoutdate()
                    self.Customername_label.text = booking.get_uname()

                    break
                } else {
                    self.label_setup(isOn: true)
                }
                
            }
        }
        
        self.configureVisibleCells()

    }
    

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if self.Calender_segmented.selectedSegmentIndex == 0 {
            if date < calendar.today! {
                self.Price_calender.deselect(date)
            } else { self.Price_calender.select(date) }
        } else {
            
            // Clear all the selected date first
            for selected_date in self.Price_calender.selectedDates{
                self.Price_calender.deselect(selected_date)
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
                    self.Price_calender.select(start_date)
                    while start_date < end_date {
                        start_date = Calendar.current.date(byAdding: .day, value: 1, to: start_date)!
                        self.Price_calender.select(start_date)
                    }
                    
                    self.label_setup(isOn: false)
                    self.checkin_date_label.text = booking.get_checkindate()
                    self.checkout_date_label.text = booking.get_checkoutdate()
                    self.Customername_label.text = booking.get_uname()
                    
                    break
                } else{
                    self.label_setup(isOn: true)

                }
            }
            
            
        }
        self.configureVisibleCells()
    }
    
    // Event Delegate
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        // Price got no event indicator
        if self.Calender_segmented.selectedSegmentIndex == 0 {
            return 0
        } else {
            
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
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.Calender_segmented.selectedSegmentIndex == 1 {
            
            return [UIColor.orange]
        } else {
            return nil
        }
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
    }
    
    
    private func load_booking() {
        //observing the data changes
        
        let ref_Homestay = Database.database().reference().child("Homestay").child(self.company_id).child(self.homestay_id).child("Booking");
        
        ref_Homestay.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                // Clearing the list
                self.listofbooking.removeAll()
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    let booking = Booking(snapshot: snap)!
                    self.listofbooking.append(booking)
                }
            }
        })
    }
    
    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    

}
