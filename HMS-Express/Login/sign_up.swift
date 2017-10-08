//
//  sign_up.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class sign_up: UIViewController,UITextFieldDelegate {

    // IBOutlet
    @IBOutlet var email_uitext: UITextField!
    @IBOutlet var password_uitext: UITextField!
    @IBOutlet var repassword_uitext: UITextField!
    @IBAction func Confirm_Signup(_ sender: AnyObject) {
        
        // UItextfield is blank
        if( (email_uitext.text?.isEmpty)! && (password_uitext.text?.isEmpty)! && (repassword_uitext.text?.isEmpty)! ){
            let alertController = UIAlertController(title: "Error", message: "Please enter your email or password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
    
        }
        
        // Password Doesn't Match
        else if ( password_uitext.text != repassword_uitext.text ){
            let alertController = UIAlertController(title: "Error", message: "Password Does not match", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        // Register
        else {
            Auth.auth().createUser(withEmail: email_uitext.text!, password: password_uitext.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func Back(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(vc!, animated: true, completion: nil)
    }
    
    // ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Delegate
        email_uitext.delegate = self
        password_uitext.delegate = self
        repassword_uitext.delegate = self

        // Draw Line
        email_uitext.useUnderLine()
        password_uitext.useUnderLine()
        repassword_uitext.useUnderLine()
        
        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


