//
//  booknow_main.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit

class booknow_main: UIViewController, UITextFieldDelegate, UIPickerViewDelegate  {

    
    // Var
    var checkin_picker = UIDatePicker()
    var checkout_picker = UIDatePicker()

    // IBOutlet
    @IBOutlet var checkin_uitext: UITextField!
    @IBOutlet var checkout_uitext: UITextField!
    @IBOutlet  var adult_uitext: UITextField!
    @IBOutlet  var children_uitext: UITextField!
    
    // IBAction
    @IBAction func AddAction_adult(_ sender: UIButton) {

    }
    
    @IBAction func MinusAction_adult(_ sender: UIButton) {

    }
    
    @IBAction func AddAction_child(_ sender: UIButton) {

    }
    
    @IBAction func MinusAction_child(_ sender: UIButton) {

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Date Picker
        checkin_picker.datePickerMode = UIDatePickerMode.date
        checkin_picker.date = .init()
        checkin_picker.minimumDate = Date()

        checkout_picker.datePickerMode = UIDatePickerMode.date
        checkout_picker.date = .init()
        checkout_picker.minimumDate = Date()

        // Toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(booknow_main.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(booknow_main.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        checkin_uitext.inputAccessoryView = toolBar
        checkin_uitext.inputView = checkin_picker
        
        // Date
        checkout_uitext.inputAccessoryView = toolBar
        checkout_uitext.inputView = checkout_picker
        // Do any additional setup after loading the view.
    }
    
    
    // Toolbar
    func donePressed(){
        view.endEditing(true)
    }
    
    func cancelPressed(){
        view.endEditing(true)
    }

    // DoneButton
    @objc func donePicker(sender: UIButton){
        if checkin_uitext.isFirstResponder{
            checkin_uitext.endEditing(true)
            
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .long
            dateformatter.timeStyle = .none
            checkin_uitext.text = dateformatter.string(from: checkin_picker.date as Date)
        }else if checkout_uitext.isFirstResponder{
            checkout_uitext.endEditing(true)
            
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .long
            dateformatter.timeStyle = .none
            checkout_uitext.text = dateformatter.string(from: checkout_picker.date as Date)
        }
    }
    
    // CancelButton
    @objc func cancelPicker(){
        if checkin_uitext.isFirstResponder{
            checkin_uitext.endEditing(true)
        }else if checkout_uitext.isFirstResponder{
            checkout_uitext.endEditing(true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}
