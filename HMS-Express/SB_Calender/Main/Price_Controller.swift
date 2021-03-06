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

class Price_Controller: UIViewController, UITextFieldDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    // Variable
    var listofprice = [ String : String ]()
    var base_price = String()
    var company_id = String()
    var homestay_id = String()
    var homestay_name = String()
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    // IBOutlet
    @IBOutlet var Price_calender: FSCalendar!
    @IBOutlet var baseprice_textfield: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_multiple" {
            let vc = segue.destination as! MultipleDate
            vc.company_id = self.company_id
            vc.homestay_id = self.homestay_id
        }
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        // Calender Delegate
        Price_calender.delegate = self
        Price_calender.dataSource = self
        self.Price_calender.register(PriceCalendarCell.self, forCellReuseIdentifier: "price_cell")
        self.load_price()
        
        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    func textFieldDidBeginEditing( _ textField: UITextField ) {
        // AlertController
        let alertController = UIAlertController(title: "Confirmation", message: "Enter the base price for the homestay", preferredStyle: .alert)
        
        // Add TextField
        alertController.addTextField {
            $0.placeholder = "Price"
            $0.addTarget(alertController, action: #selector(alertController.textDidChangeInLoginAlert), for: .editingChanged)
        }
        
        // confirmAction
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
            
            guard let price_input = alertController.textFields![0].text else { return }
            
            let price_ref = Database.database().reference().child("Homestay").child(self.company_id).child(self.homestay_id)
            
            price_ref.child("Base_Price").setValue(price_input)
            self.base_price = "$ " + price_input
            self.baseprice_textfield.text = price_input
            self.load_price()
            self.Price_calender.reloadData()
            self.Price_calender.configureAppearance()
        })
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
        
        confirmAction.isEnabled = false
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func textFieldDidEndEditing( _ textField: UITextField) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func load_price() {
        //observing the data changes
        
        let price_ref = Database.database().reference().child("Homestay").child(self.company_id).child(self.homestay_id).child("Base_Price")
        let specialprice_ref = Database.database().reference().child("Homestay").child(self.company_id).child(self.homestay_id).child("Price")

        // Get base_Prcie
        price_ref.observeSingleEvent(of: DataEventType.value , with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.exists() {
                var price = snapshot.value as! String
                self.base_price = "$" + price
                self.Price_calender.reloadData()
                self.Price_calender.configureAppearance()

            } else {
                self.base_price = "$0"
                self.baseprice_textfield.text = self.base_price
                self.Price_calender.reloadData()
                self.Price_calender.configureAppearance()
            }
        })
 
        specialprice_ref.observeSingleEvent(of: DataEventType.value , with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                // Clearing the list
                self.listofprice.removeAll()
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    let date = snap.key
                    let price = snap.value as! String
                    self.listofprice[date] = price
                    
                    if self.listofprice.count == snapshot.childrenCount {
                        self.Price_calender.reloadData()
                        self.Price_calender.configureAppearance()
                        
                    }
                }
                
            }
        })
        
    }
    
    // MARK : Calender Delegate
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        for item in listofprice {
            if (self.formatter.date(from: item.key)!) == date {
                return "$" + String(item.value)
            }
        }
        return self.base_price
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
            self.Price_calender.deselect(date)
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
    
    
    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}
