//
//  pax_picker.swift
//  HMS-Express
//
//  Created by Ding Zhan on 07/01/2018.
//  Copyright © 2018 Ding Zhan Chia. All rights reserved.
//

import Foundation
import UIKit

extension booknow_confirmation  {
    
    
    // PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return title_pax.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,forComponent component: Int) -> String? {
        return title_pax[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int) {
        if self.cust_title.isFirstResponder{
            self.cust_title.text = title_pax[row]
            self.title_picker.reloadAllComponents();
        }
    }
    
    func pickUp(_ textField : UITextField){
        
        if textField == self.cust_title {
            self.title_picker.delegate = self
            self.title_picker.dataSource = self
        }
        
        // Toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 40/255, green: 88/255, blue: 123/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector( self.donePicker ))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector( self.cancelPicker) )
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Delegate
        textField.inputAccessoryView = toolBar
        textField.inputView = self.title_picker
    }
    
    

    
    // DoneButton
    @objc func donePicker(){
        if self.cust_title.isFirstResponder{
            self.cust_title.endEditing(true)
        }
    }
    
    // CancelButton
    @objc func cancelPicker(){
        if self.cust_title.isFirstResponder{
            self.cust_title.endEditing(true)
        }
    }
    
}
