//
//  booknow_confirmation.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

class booknow_confirmation: UIViewController, UIPickerViewDelegate , UIPickerViewDataSource, UITextFieldDelegate {

    // Variable
    var information = [ String : Any ]()
    var homestay_information = [ String : AnyObject ]()
    var customer = Customer()
    private var name = String()
    var price = Int()
    
    fileprivate var curruser = Employee()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter
    }()
    fileprivate let formatter_default: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var title_pax  = ["Please Select", "Mr.", "Mrs.", "Miss"]
    var title_picker = UIPickerView()

    // IBOutlet
    @IBOutlet weak var Customer_Name: UILabel!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var Phone_num: UILabel!
    @IBOutlet weak var Homestay_name: UILabel!
    @IBOutlet weak var Checkout_label: UILabel!
    @IBOutlet weak var Checkin_label: UILabel!
    @IBOutlet weak var Total_Price: UILabel!
    @IBOutlet weak var deposit_uitext: UITextField!
    @IBOutlet weak var note_uitext: UITextField!

    @IBOutlet var cust_firstname_text: UITextField!
    @IBOutlet var cust_lastname_text: UITextField!
    @IBOutlet var cust_contact : UITextField!
    @IBOutlet var cust_email : UITextField!
    @IBOutlet var cust_title: UITextField!
    
    
    @IBAction func submit_button(_ sender: UIButton) {
        
        if !(self.isValidPrice(self.deposit_uitext.text!)) {
            let alert = UIAlertController(title: "", message: "One of the price has not entered. Please do the price setup in Homestay.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Comfirm", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if ( (self.cust_firstname_text.text?.isEmpty)! || (self.cust_lastname_text.text?.isEmpty)! || (self.cust_contact.text?.isEmpty)!
            || (self.cust_email.text?.isEmpty)!) {
            let alert = UIAlertController(title: "", message: "Please enter all the mandatory information for customer", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Comfirm", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "", message: "Confirm all of the information entered are correct?", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Confirm!", style: .default , handler: { (action)-> Void in
                self.confirm()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func confirm() {
        
        // All reference
        let key = Database.database().reference().child("Booking").child(self.information["cid"] as! String).childByAutoId().key
        let booking_ref = Database.database().reference().child("Booking").child(self.information["cid"] as! String).child(key)
        let homestay_ref = Database.database().reference().child("Homestay").child(self.information["cid"] as! String).child(self.information["hid"] as! String)
        
        // Update Customer Details
        self.customer.set_fullname(self.cust_lastname_text.text! + self.cust_firstname_text.text!)
        self.customer.set_lastnam((self.cust_lastname_text.text)!)
        self.customer.set_firstname((self.cust_firstname_text.text)!)
        self.customer.set_email(self.cust_email.text!)
        self.customer.set_phonenumber(self.cust_contact.text!)
        self.customer.set_CID(key)
        
        // Update Booking Details
        let booking_info = Booking()
        booking_info.set_bid(key)
        booking_info.set_cid(self.information["cid"] as! String)
        booking_info.set_hid(self.information["hid"] as! String)
        booking_info.set_uid(self.customer.get_CID())
        booking_info.set_checkindate(self.formatter_default.string( from : self.information["checkin_date"]  as! Date ))
        booking_info.set_checkoutdate(self.formatter_default.string( from : self.information["checkout_date"]  as! Date))
        booking_info.set_hname(self.Homestay_name.text!)
        booking_info.set_uname(self.customer.get_fullname())
        booking_info.set_totalprice(String(self.price))
        booking_info.set_deposit(self.deposit_uitext.text!)
        booking_info.set_note(self.note_uitext.text!)
        
        // Set who register this
        booking_info.set_registered(self.curruser.get_UID())
        
        homestay_ref.child("Booking").child(key).setValue(booking_info.convert_to_list())
        booking_ref.setValue(booking_info.convert_to_list())
        
        let sb = UIStoryboard( name : "MainController", bundle : nil )
        let vc = sb.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 0
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.start_queue()

        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }


    
    func UIText_setup(){
        print(self.homestay_information)
        self.Homestay_name.text = self.homestay_information["Name"] as? String
        self.Checkin_label.text = formatter.string(from: self.information["checkin_date"]  as! Date )
        self.Checkout_label.text = formatter.string(from: self.information["checkout_date"]  as! Date)
        self.Total_Price.text = "RM " + String(price)
        
        self.cust_email.useUnderLine()
        self.cust_contact.useUnderLine()
        self.cust_lastname_text.useUnderLine()
        self.cust_firstname_text.useUnderLine()
        self.cust_title.useUnderLine()
        self.deposit_uitext.useUnderLine()
        self.note_uitext.useUnderLine()
        
        // delegate for picker
        self.cust_title.delegate = self
        
    }
    
    // Keyboard Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing( _ textField: UITextField ) {
        if textField == self.cust_title {
            self.pickUp(textField)
        } else {
            textField.useUnderLine_whileediting()
        }
    }

    func textFieldDidEndEditing( _ textField: UITextField) {
        textField.useUnderLine()
    }
    
    func isValidPrice(_ price: String) -> Bool {
        return !price.isEmpty && price.isNumber
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // Function: start_queue -> Void
    func start_queue(){
        let ref = Database.database().reference(withPath: "System_User")
        let uid : String = (Auth.auth().currentUser?.uid)!
        ref.child(uid).observe(.value, with: { snapshot in
            if snapshot.exists(){
                self.curruser = Employee.init(snapshot: snapshot)!
                self.UIText_setup()
            }
        })
    }
    
}
