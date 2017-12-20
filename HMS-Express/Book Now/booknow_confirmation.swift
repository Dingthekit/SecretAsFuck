//
//  booknow_confirmation.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

class booknow_confirmation: UIViewController {

    // Variable
    var customer = Customer()
    var name = String()
    var homestay = Homestay_schema1()
    var checkin_date = Date()
    var checkout_date = Date()
    var company_id = String()
    var homestay_id = String()
    var price = Int()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy EEEE"
        return formatter
    }()
    fileprivate let formatter_default: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
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

    @IBAction func submit_button(_ sender: UIButton) {
        
        if !(self.isValidPrice(self.deposit_uitext.text!)) {
            let alert = UIAlertController(title: "", message: "One of the price has not entered. Please do the price setup in Homestay.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Comfirm", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let key = Database.database().reference().child("Booking").child(self.company_id).childByAutoId().key
            let booking_ref = Database.database().reference().child("Booking").child(self.company_id).child(key)
            let homestay_ref = Database.database().reference().child("Homestay").child(self.company_id).child(self.homestay_id)
            
            let booking_info = Booking()
            booking_info.set_bid(key)
            booking_info.set_cid(self.company_id)
            booking_info.set_hid(self.homestay_id)
            booking_info.set_uid(self.customer.get_CID())
            booking_info.set_checkindate(self.formatter_default.string( from : self.checkin_date as Date))
            booking_info.set_checkoutdate((self.formatter_default.string( from : self.checkout_date as Date)))
            booking_info.set_hname(self.homestay.get_name())
            booking_info.set_uname(self.customer.get_fullname())
            booking_info.set_totalprice(String(self.price))
            booking_info.set_deposit(self.deposit_uitext.text!)
            booking_info.set_note(self.note_uitext.text!)
            
            homestay_ref.child("Booking").child(key).setValue(booking_info.convert_to_list())
            booking_ref.setValue(booking_info.convert_to_list())
            
            let sb = UIStoryboard( name : "MainController", bundle : nil )
            let vc = sb.instantiateViewController(withIdentifier: "Home") as! UITabBarController
            vc.selectedIndex = 0
            self.present(vc, animated: true, completion: nil)
        }


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UIText_setup()
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    func UIText_setup(){
        
        self.Customer_Name.text = customer.get_fullname()
        self.Homestay_name.text = homestay.get_name()
        self.Email.text = customer.get_email()
        self.Phone_num.text = customer.get_phonenumber()
        self.Checkin_label.text = formatter.string(from: self.checkin_date as Date).uppercased()
        self.Checkout_label.text = formatter.string(from: self.checkout_date as Date).uppercased()
        self.Total_Price.text = "RM " + String(price)
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
    
}
