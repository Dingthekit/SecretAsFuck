//
//  booknow_customer_registration.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit

class booknow_customer_registration: UIViewController, UITextFieldDelegate {

    @IBOutlet var name_uitext: UITextField!
    @IBOutlet var gender_uitext: UITextField!
    @IBOutlet var email_uitext: UITextField!
    @IBOutlet var contact_uitext: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name_uitext.delegate = self
        gender_uitext.delegate = self
        email_uitext.delegate = self
        contact_uitext.delegate = self
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
    
    func cancelPressed(){
        view.endEditing(true) // or do something
    }

}
