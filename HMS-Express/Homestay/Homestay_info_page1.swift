//
//  Homestay_info_page1.swift
//  
//
//  Created by Ding Zhan Chia on 22/09/2017.
//

import UIKit
import Firebase
import FirebaseAuth

class Homestay_info_page1: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {

    // Picker Variable
    private var no_pax  = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    var no_pax_picker = UIPickerView()

    // PageControl
    var pageControl = UIPageControl()
    
    // IBoutlet
    @IBOutlet var Name : UITextField!
    @IBOutlet var Address_1 : UITextField!
    @IBOutlet var Address_2 : UITextField!
    @IBOutlet var Postal_code: UITextField!
    @IBOutlet var City: UITextField!
    @IBOutlet var Type_Homestay : UITextField!
    @IBOutlet var Capacity_Homestay: UITextField!
    
    // IBAction
    @IBAction func confirm_button(_ sender: AnyObject) {
        let sb = UIStoryboard( name : "MainController", bundle : nil )
        let vc = sb.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 1
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Number of pax
        no_pax_picker.delegate = self
        no_pax_picker.dataSource = self
        
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
         
        // Picker_setup
        //Capacity_Homestay.inputAccessoryView = toolBar
        //Capacity_Homestay.inputView = no_pax_picker
        
        // PageControl
        configurePageControl(0)
        
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int){
        
    }
    
    // Page Control
    func configurePageControl( _ CurrPage : Int) {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = CurrPage
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    // DoneButton
    @objc func donePicker(){
        Type_Homestay.endEditing(true)
    }
    
    // CancelButton
    @objc func cancelPicker(){
        Type_Homestay.endEditing(true)
    }
}
