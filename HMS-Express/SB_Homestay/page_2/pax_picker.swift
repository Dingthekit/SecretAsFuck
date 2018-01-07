//
//  pax_picker.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 24/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit

class pax_picker: UIPickerView, UIPickerViewDelegate , UIPickerViewDataSource {
    
 var no_pax  = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]

    // PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return no_pax.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,forComponent component: Int) -> String? {
        return no_pax[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int){
    }
    
}
