//
//  MultipleDate.swift
//  HMS-Express
//
//  Created by Ding Zhan on 17/01/2018.
//  Copyright © 2018 Ding Zhan Chia. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase

class MultipleDate: UIViewController,FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance  {

    var listofprice = [ String : String ]()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var company_id = String()
    var homestay_id = String()
    var homestay_name = String()
    var base_price = String()
    fileprivate let gregorian = Calendar(identifier: .gregorian)

    
    @IBOutlet var Title_Instructions: UILabel!
    @IBOutlet var Date_Calender: FSCalendar!
    @IBOutlet var Done_button: UIButton!
    
    @IBAction func done(_ sender: UIButton) {
        // AlertController
        let alertController = UIAlertController(title: "", message: "Enter the prices for selected date(s)", preferredStyle: .alert)
        
        // Add TextField
        alertController.addTextField {
            $0.placeholder = "Price"
            $0.addTarget(alertController, action: #selector(alertController.textDidChangeInLoginAlert), for: .editingChanged)
        }
        
        // confirmAction
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
            
            guard let price_input = alertController.textFields![0].text else { return }
            
            for date in self.Date_Calender.selectedDates{
                self.Date_Calender.deselect(date)
                self.listofprice[self.formatter.string(from: date)] = price_input
            }
            
            self.Title_Instructions.text = "Step 1 : Select the date(s) that prices need to be modified"
            self.Done_button.isEnabled = false
            self.Done_button.alpha = 0.5
            
            let ref = Database.database().reference().child("Homestay").child(self.company_id).child(self.homestay_id)
            ref.child("Price").setValue(self.listofprice)
            self.load_price()
            self.Date_Calender.reloadData()
            
            
        })
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
        
        confirmAction.isEnabled = false
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Done_button.isEnabled = false
        self.Done_button.alpha = 0.5
        
        self.Date_Calender.register(PriceCalendarCell.self, forCellReuseIdentifier: "price_cell")
        self.load_price()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.Date_Calender.reloadData()
                self.Date_Calender.configureAppearance()
                
            } else {
                self.base_price = "$0"
                self.Date_Calender.reloadData()
                self.Date_Calender.configureAppearance()
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
                        self.Date_Calender.reloadData()
                        self.Date_Calender.configureAppearance()
                        
                    }
                }
                
            }
        })
        
    }
    
    // MARK : Calender delegate
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
        }
        return UIColor.white
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        if calendar.selectedDates.count >= 1 {
            self.Title_Instructions.text = "Step 2 : Click Submit when done selecting the date(s)"
            self.Done_button.isEnabled = true
            self.Done_button.alpha = 1
        } else {
            self.Title_Instructions.text = "Step 1 : Select the date(s) that prices need to be modified"
            self.Done_button.isEnabled = false
            self.Done_button.alpha = 0.5
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if date < calendar.today! {
            calendar.deselect(date)
        }
        
        if calendar.selectedDates.count >= 1 {
            self.Title_Instructions.text = "Step 2 : Click Submit when done selecting the date(s)"
            self.Done_button.isEnabled = true
            self.Done_button.alpha = 1
        } else {
            self.Title_Instructions.text = "Step 1 : Select the date(s) that prices need to be modified"
            self.Done_button.isEnabled = false
            self.Done_button.alpha = 0.5
        }
    }
    
    
    func configureVisibleCells() {
        self.Date_Calender.visibleCells().forEach { (cell) in
            let date = self.Date_Calender.date(for: cell)
            let position = self.Date_Calender.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! PriceCalendarCell)
        
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if self.Date_Calender.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if self.Date_Calender.selectedDates.contains(date) {
                    
                    if self.Date_Calender.selectedDates.contains(previousDate) && self.Date_Calender.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    } else if self.Date_Calender.selectedDates.contains(previousDate) && self.Date_Calender.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    } else if self.Date_Calender.selectedDates.contains(nextDate) {
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
