//
//  booknow_customer_registration.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

class booknow_customer_registration: UIViewController, UITextFieldDelegate {

    // Variable
    fileprivate  var curruser = Employee()
    fileprivate let ref = Database.database().reference(withPath: "System_User")

    // IBOutlet
    @IBOutlet var firstname_uitext: UITextField!
    @IBOutlet var lastname_uitext: UITextField!
    @IBOutlet var email_uitext: UITextField!
    @IBOutlet var contact_uitext: UITextField!
    
    // IBAction
    @IBAction func next_button(_ sender: Any) {
        
        let CID : String = self.curruser.get_CID()
        let key = Database.database().reference().child("Customer").child(CID).childByAutoId().key
        let customerref = Database.database().reference().child("Customer").child(CID).child(key)
        let customer_info = Customer.init( first_name: self.firstname_uitext.text! , last_name: self.lastname_uitext.text! , full_name: self.lastname_uitext.text! + " " + self.firstname_uitext.text! ,phonenumber: self.contact_uitext.text!,email: self.email_uitext.text!  )
        customerref.setValue( customer_info.convert_to_list() )
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        start_queue()
        
        firstname_uitext.useUnderLine()
        lastname_uitext.useUnderLine()
        email_uitext.useUnderLine()
        contact_uitext.useUnderLine()

        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    // Keyboard Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // start_queue for user information
    func start_queue(){
        
        let uid : String = (Auth.auth().currentUser?.uid)!
        self.ref.child(uid).observe(.value, with: { snapshot in
            if snapshot.exists(){
                self.curruser = Employee.init(snapshot: snapshot)!
                print(self.curruser.get_CID())
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
