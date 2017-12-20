
//
//  Homestay_info_page2.swift
//  
//
//  Created by Ding Zhan Chia on 22/09/2017.
//

import UIKit

class Homestay_info_page2: UIViewController, UIPickerViewDelegate , UIPickerViewDataSource, UITextFieldDelegate   {

    // Variable
    var homestay_info_1 = Homestay_schema1() ;
    var homestay_info_2 = Homestay_schema2() ;
    var homestay_info_3 = Homestay_schema3() ;

    // Picker Variable
    private var no_pax  = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    private var washroom_pax  = ["0","1","1.5","2","2.5","3","3.5","4", "4.5","5","5.5"]
    var no_pax_picker = UIPickerView()
    
    // IBOutlet
    @IBOutlet var capacity_homestay: UITextField!
    @IBOutlet var capacity_bedroom: UITextField!
    @IBOutlet var capacity_bathroom: UITextField!
    @IBOutlet var king_bed: UITextField!
    @IBOutlet var queen_bed: UITextField!
    @IBOutlet var single_bed: UITextField!

    @IBAction func next_button(_ sender: Any) {
        if ((self.capacity_homestay.text?.isEmpty)! || (self.capacity_bedroom.text?.isEmpty)! || (self.capacity_bathroom.text?.isEmpty)! || (self.king_bed.text?.isEmpty)! || (self.queen_bed.text?.isEmpty)! || (self.single_bed.text?.isEmpty)! ){
            
            let alert = UIAlertController(title: "", message: "Please fill up all the information.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            self.performSegue(withIdentifier: "to_last", sender: self)
        }
    }
    
    // Prepare Segue
    // 1. next_3
    // 2. back_1
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_last" {
            
            let vc = segue.destination as! Homestay_info_page3
            
            homestay_info_2.set_guest(capacity_homestay.text!)
            homestay_info_2.set_bedroom(capacity_bedroom.text!)
            homestay_info_2.set_bathroom(capacity_bathroom.text!)
            homestay_info_2.set_kingbed(king_bed.text! )
            homestay_info_2.set_queenbed(queen_bed.text!)
            homestay_info_2.set_singlebed(single_bed.text!)
            
            vc.homestay_info_1 = homestay_info_1.copy() as! Homestay_schema1
            vc.homestay_info_2 = homestay_info_2.copy() as! Homestay_schema2
            vc.homestay_info_3 = homestay_info_3.copy() as! Homestay_schema3
            
        } else if segue.identifier == "back_1" {
            
            let vc = segue.destination as! Homestay_info_page1
            
            homestay_info_2.set_guest(capacity_homestay.text!)
            homestay_info_2.set_bedroom(capacity_bedroom.text!)
            homestay_info_2.set_bathroom(capacity_bathroom.text!)
            homestay_info_2.set_kingbed(king_bed.text! )
            homestay_info_2.set_queenbed(queen_bed.text!)
            homestay_info_2.set_singlebed(single_bed.text!)
            
            vc.homestay_info_1 = homestay_info_1.copy() as! Homestay_schema1
            vc.homestay_info_2 = homestay_info_2.copy() as! Homestay_schema2
            vc.homestay_info_3 = homestay_info_3.copy() as! Homestay_schema3
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate
        capacity_homestay.delegate = self
        capacity_bedroom.delegate = self
        capacity_bathroom.delegate = self
        king_bed.delegate = self
        queen_bed.delegate = self
        single_bed.delegate = self
        
        
        // Underline
        capacity_homestay.useUnderLine()
        capacity_bedroom.useUnderLine()
        capacity_bathroom.useUnderLine()
        king_bed.useUnderLine()
        single_bed.useUnderLine()
        queen_bed.useUnderLine()
        
        // Set default value of the UItext
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
        if capacity_bathroom.isFirstResponder{
            return washroom_pax.count
        } else {
            return no_pax.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,forComponent component: Int) -> String? {
        if capacity_bathroom.isFirstResponder{
            return washroom_pax[row]
        } else {
            return no_pax[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int) {
        if capacity_homestay.isFirstResponder{
            capacity_homestay.text = no_pax[row]
            no_pax_picker.reloadAllComponents();

        } else if capacity_bedroom.isFirstResponder{
            capacity_bedroom.text = no_pax[row]
            no_pax_picker.reloadAllComponents();

        } else if capacity_bathroom.isFirstResponder{
            capacity_bathroom.text = washroom_pax[row]
            no_pax_picker.reloadAllComponents();

        } else if king_bed.isFirstResponder{
            king_bed.text = no_pax[row]
            no_pax_picker.reloadAllComponents();

        } else if queen_bed.isFirstResponder{
            queen_bed.text = no_pax[row]
            no_pax_picker.reloadAllComponents();

        } else if single_bed.isFirstResponder{
            single_bed.text = no_pax[row]
            no_pax_picker.reloadAllComponents();

        }
        
    }
    
    func pickUp(_ textField : UITextField){
        
        // Number of pax
        self.no_pax_picker.delegate = self
        self.no_pax_picker.dataSource = self
        self.no_pax_picker.reloadAllComponents();

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
        self.no_pax_picker.reloadAllComponents()
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
        
        if !(homestay_info_2.get_guest().isEmpty) {
            capacity_homestay.text = homestay_info_2.get_guest()
        }
        
        if !(homestay_info_2.get_bedroom().isEmpty) {
            capacity_bedroom.text = homestay_info_2.get_bedroom()
        }
        if !(homestay_info_2.get_bathroom().isEmpty) {
            capacity_bathroom.text = homestay_info_2.get_bathroom()
        }
        if !(homestay_info_2.get_kingbed().isEmpty) {
            king_bed.text = homestay_info_2.get_kingbed()
        }
        if !(homestay_info_2.get_queenbed().isEmpty) {
            queen_bed.text = homestay_info_2.get_queenbed()
        }
        if !(homestay_info_2.get_singlebed().isEmpty) {
            single_bed.text = homestay_info_2.get_singlebed()
        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

