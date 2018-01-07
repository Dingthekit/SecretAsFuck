//
//  Bookinglist_information.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 26/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

class Bookinglist_information: UIViewController {

    var booking_info = Booking()
    
    @IBOutlet weak var arrival: UILabel!
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var customer_name: UILabel!
    @IBOutlet weak var homestay_name: UILabel!
    
    @IBOutlet weak var deposit_label: UILabel!
    @IBOutlet weak var payment_label: UILabel!
    @IBOutlet weak var note_label: UILabel!

    @IBOutlet weak var deposit_button: ToggleButton!
    @IBOutlet weak var payment_button: ToggleButton!
    
    @IBAction func deposit_action(_ sender: ToggleButton) {
        
        if !deposit_button.isOn {
            let alert = UIAlertController(title: "", message: "The deposit of the booking has received?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action)-> Void in
                self.deposit_button.buttonPressed()
            }))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action)-> Void in
                let booking_ref =  Database.database().reference().child("Booking").child(self.booking_info.get_cid()).child(self.booking_info.get_bid())
                let homestay_ref = Database.database().reference().child("Homestay").child(self.booking_info.get_cid()).child(self.booking_info.get_hid()).child("Booking").child(self.booking_info.get_bid())
                booking_ref.child("Payment").setValue(self.booking_info.get_deposit())
                homestay_ref.child("Payment").setValue(self.booking_info.get_deposit())
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "", message: "The deposit of the booking has NOT received?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action)-> Void in
                self.deposit_button.buttonPressed()
        }))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action)-> Void in
                
                if self.payment_button.isOn {
                    self.payment_button.buttonPressed()

                }
                
                let booking_ref =  Database.database().reference().child("Booking").child(self.booking_info.get_cid()).child(self.booking_info.get_bid())
                let homestay_ref = Database.database().reference().child("Homestay").child(self.booking_info.get_cid()).child(self.booking_info.get_hid()).child("Booking").child(self.booking_info.get_bid())
                booking_ref.child("Payment").setValue("0")
                homestay_ref.child("Payment").setValue("0")
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }

        
    }
    
    @IBAction func payment_action(_ sender: ToggleButton) {
        
        
        if !payment_button.isOn {
            let alert = UIAlertController(title: "", message: "The full payment of the booking has received?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action)-> Void in
                self.payment_button.buttonPressed()
            }))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action)-> Void in
                
                if !self.deposit_button.isOn {
                    self.deposit_button.buttonPressed()
                }
                
                let booking_ref =  Database.database().reference().child("Booking").child(self.booking_info.get_cid()).child(self.booking_info.get_bid())
                let homestay_ref = Database.database().reference().child("Homestay").child(self.booking_info.get_cid()).child(self.booking_info.get_hid()).child("Booking").child(self.booking_info.get_bid())
                booking_ref.child("Payment").setValue(self.booking_info.get_totalprice())
                homestay_ref.child("Payment").setValue(self.booking_info.get_totalprice())
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "", message: "The full payment of the booking has NOT received?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action)-> Void in
                self.payment_button.buttonPressed()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action)-> Void in
                
                if self.deposit_button.isOn {
                    self.deposit_button.buttonPressed()
                }

                let booking_ref =  Database.database().reference().child("Booking").child(self.booking_info.get_cid()).child(self.booking_info.get_bid())
                let homestay_ref = Database.database().reference().child("Homestay").child(self.booking_info.get_cid()).child(self.booking_info.get_hid()).child("Booking").child(self.booking_info.get_bid())
                booking_ref.child("Payment").setValue("0")
                homestay_ref.child("Payment").setValue("0")
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.deposit_button.initButton("Paid")
        self.deposit_button.activateButton(bool: false)
        self.payment_button.initButton("Paid")
        self.payment_button.activateButton(bool: false)
        
        setup_uilabel()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup_uilabel(){
        self.arrival.text = booking_info.get_checkindate()
        self.departure.text = booking_info.get_checkoutdate()
        self.customer_name.text = booking_info.get_hname()
        self.homestay_name.text = booking_info.get_uname()
        if (booking_info.get_note().isEmpty){
            self.note_label.text = "No comment"
        } else {
            self.note_label.text = booking_info.get_note()
        }
        
        self.deposit_label.text = "RM" + booking_info.get_deposit()
        self.payment_label.text = "RM" + booking_info.get_totalprice()

        if (booking_info.get_payment() == booking_info.get_deposit() ) {
            deposit_button.buttonPressed()
        } else if (booking_info.get_payment() == booking_info.get_totalprice() ) {
            deposit_button.buttonPressed()
            payment_button.buttonPressed()
        } else {

        }
        
        
    }
    


}
