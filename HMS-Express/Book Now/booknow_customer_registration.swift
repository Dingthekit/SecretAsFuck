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

    @IBOutlet var firstname_uitext: UITextField!
    @IBOutlet var lastname_uitext: UITextField!
    @IBOutlet var email_uitext: UITextField!
    @IBOutlet var contact_uitext: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    @IBAction func next_button(_ sender: UIButton) {
        
        let key = Database.database().reference(withPath: "Customer").childByAutoId().key
        let ref = Database.database().reference(withPath: "Customer")
        
        var customer_info = Customer.init(email: self.firstname_uitext.text! , first_name: self.lastname_uitext.text! , last_name: self.email_uitext.text! , phonenumber: self.contact_uitext.text! )
        
        ref.child(key).setValue(customer_info.convert_to_list())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Keyboard return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    

    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

}
