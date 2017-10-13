//
//  Homestay_info_page1.swift
//  
//
//  Created by Ding Zhan Chia on 22/09/2017.
//

import UIKit
import Firebase
import FirebaseAuth

class Homestay_info_page1: UIViewController, UITextFieldDelegate {
    
    // Variable
    var homestay_info_1 = Homestay_schema1() ;
    var homestay_info_2 = Homestay_schema2() ;
    var homestay_info_3 = Homestay_schema3() ;
    
    // PageControl
    var pageControl = UIPageControl()
    
    // IBoutlet
    @IBOutlet var Name : UITextField!
    @IBOutlet var Address_1 : UITextField!
    @IBOutlet var Address_2 : UITextField!
    @IBOutlet var Postal_code: UITextField!
    @IBOutlet var City: UITextField!
    @IBOutlet var State: UITextField!
    @IBOutlet var Type_Homestay : UITextField!
 
    @IBAction func back_button(_ sender: Any) {
        
        // Navigate to the next item
        let sb = UIStoryboard( name : "MainController", bundle : nil )
        let vc = sb.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 2
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "next_2" {
            
            homestay_info_1.set_name(Name.text!)
            homestay_info_1.set_add1(Address_1.text!)
            homestay_info_1.set_add2(Address_2.text!)
            homestay_info_1.set_pos(Postal_code.text!)
            homestay_info_1.set_city(City.text!)
            homestay_info_1.set_state(State.text!)
            homestay_info_1.set_type(Type_Homestay.text!)
            
            let vc = segue.destination as! Homestay_info_page2
            vc.homestay_info_1 = homestay_info_1.copy() as! Homestay_schema1
            vc.homestay_info_2 = homestay_info_2.copy() as! Homestay_schema2
            vc.homestay_info_3 = homestay_info_3.copy() as! Homestay_schema3
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.Name.delegate = self
        defaultvalue()
        
        // Use underline
        Name.useUnderLine()
        Address_1.useUnderLine()
        Address_2.useUnderLine()
        Postal_code.useUnderLine()
        City.useUnderLine()
        State.useUnderLine()
        Type_Homestay.useUnderLine()
        
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
    

    func defaultvalue(){
        
        if !(homestay_info_1.get_name().isEmpty) {
            Name.text = homestay_info_1.get_name()
        }

        if !(homestay_info_1.get_add1().isEmpty) {
            Address_1.text = homestay_info_1.get_add1()
        }
        if !(homestay_info_1.get_add2().isEmpty) {
            Address_2.text = homestay_info_1.get_add2()
        }
        if !(homestay_info_1.get_pos().isEmpty) {
            Postal_code.text = homestay_info_1.get_pos()
        }
        if !(homestay_info_1.get_city().isEmpty) {
            City.text = homestay_info_1.get_city()
        }
        if !(homestay_info_1.get_state().isEmpty) {
            State.text = homestay_info_1.get_state()
        }
        if !(homestay_info_1.get_type().isEmpty) {
            Type_Homestay.text = homestay_info_1.get_type()
        }
    }
}

