
//
//  Homestay_info_page2.swift
//  
//
//  Created by Ding Zhan Chia on 22/09/2017.
//

import UIKit

class Homestay_info_page2: UIViewController, UIPickerViewDelegate , UIPickerViewDataSource, UITextFieldDelegate  {

    // Variable
    var homestay_info_1 = Homestay_schema1() ;
    var homestay_info_2 = Homestay_schema2() ;
    var homestay_info_3 = Homestay_schema3() ;

    // Picker Variable
    private var no_pax  = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    var no_pax_picker = UIPickerView()
    
    // IBOutlet
    @IBOutlet var capacity_homestay: UITextField!
    @IBOutlet var capacity_bedroom: UITextField!
    @IBOutlet var capacity_bathroom: UITextField!
    @IBOutlet var king_bed: UITextField!
    @IBOutlet var queen_bed: UITextField!
    @IBOutlet var single_bed: UITextField!
    
    
    @IBAction func back_button(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homestay_info_page1") as! Homestay_info_page1

        homestay_info_2 =  Homestay_schema2.init( guest: capacity_homestay.text! , bedroom: capacity_bedroom.text! , bathroom: capacity_bathroom.text!, kingbed: king_bed.text! , queenbed: queen_bed.text! , singlebed: single_bed.text! )
        
        vc.homestay_info_1 = homestay_info_1.copy() as! Homestay_schema1
        vc.homestay_info_2 = homestay_info_2.copy() as! Homestay_schema2
        vc.homestay_info_3 = homestay_info_3.copy() as! Homestay_schema3

        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func next_button(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homestay_info_page3") as! Homestay_info_page3
        homestay_info_2 =  Homestay_schema2.init( guest: capacity_homestay.text! , bedroom: capacity_bedroom.text! , bathroom: capacity_bathroom.text!, kingbed: king_bed.text! , queenbed: queen_bed.text! , singlebed: single_bed.text! )
        vc.homestay_info_1 = homestay_info_1.copy() as! Homestay_schema1
        vc.homestay_info_2 = homestay_info_2.copy() as! Homestay_schema2
        vc.homestay_info_3 = homestay_info_3.copy() as! Homestay_schema3
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(homestay_info_1.name)
        // Delegate
        capacity_homestay.delegate = self
        capacity_bedroom.delegate = self
        capacity_bathroom.delegate = self
        king_bed.delegate = self
        queen_bed.delegate = self
        single_bed.delegate = self
        
        defaultvalue()
        
        
        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int) {
        if capacity_homestay.isFirstResponder{
            capacity_homestay.text = no_pax[row]
            
        } else if capacity_bedroom.isFirstResponder{
            capacity_bedroom.text = no_pax[row]
            
        } else if capacity_bathroom.isFirstResponder{
            capacity_bathroom.text = no_pax[row]
            
        } else if king_bed.isFirstResponder{
            king_bed.text = no_pax[row]
            
        } else if queen_bed.isFirstResponder{
            queen_bed.text = no_pax[row]
            
        } else if single_bed.isFirstResponder{
            single_bed.text = no_pax[row]
        }
    }
    
    func pickUp(_ textField : UITextField){
        
        // Number of pax
        self.no_pax_picker.delegate = self
        self.no_pax_picker.dataSource = self
        
        // Toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector( self.donePicker ))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector( self.cancelPicker) )
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Delegate
        textField.inputAccessoryView = toolBar
        textField.inputView = no_pax_picker
    }
    
    
    
    
    // BeginEdit
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(textField)
    }
    
    // DoneButton
    @objc func donePicker(){
        if capacity_homestay.isFirstResponder{
            capacity_homestay.endEditing(true)
        } else if capacity_bedroom.isFirstResponder{
            capacity_bedroom.endEditing(true)
        } else if capacity_bathroom.isFirstResponder{
            capacity_bathroom.endEditing(true)
        } else if king_bed.isFirstResponder{
            king_bed.endEditing(true)
        } else if queen_bed.isFirstResponder{
            queen_bed.endEditing(true)
        } else if single_bed.isFirstResponder{
            single_bed.endEditing(true)
        }
    }
    
    // CancelButton
    @objc func cancelPicker(){
        if capacity_homestay.isFirstResponder{
            capacity_homestay.endEditing(true)
        } else if capacity_bedroom.isFirstResponder{
            capacity_bedroom.endEditing(true)
        } else if capacity_bathroom.isFirstResponder{
            capacity_bathroom.endEditing(true)
        } else if king_bed.isFirstResponder{
            king_bed.endEditing(true)
        } else if queen_bed.isFirstResponder{
            queen_bed.endEditing(true)
        } else if single_bed.isFirstResponder{
            single_bed.endEditing(true)
        }
    }

    func defaultvalue(){
        
        if !(homestay_info_2.guest.isEmpty) {
            capacity_homestay.text = homestay_info_2.guest
        }
        
        if !(homestay_info_2.bedroom.isEmpty) {
            capacity_bedroom.text = homestay_info_2.bedroom
        }
        if !(homestay_info_2.bathroom.isEmpty) {
            capacity_bathroom.text = homestay_info_2.bathroom
        }
        if !(homestay_info_2.kingbed.isEmpty) {
            king_bed.text = homestay_info_2.kingbed
        }
        if !(homestay_info_2.queenbed.isEmpty) {
            queen_bed.text = homestay_info_2.queenbed
        }
        if !(homestay_info_2.singlebed.isEmpty) {
            single_bed.text = homestay_info_2.singlebed
        }

    }
}
