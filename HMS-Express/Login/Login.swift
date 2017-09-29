//
//  Login.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Login: UIViewController, UITextFieldDelegate {
    
    // OBoutlet
    @IBOutlet var email_uitext: UITextField!
    @IBOutlet var password_uitext: UITextField!
    @IBAction func loginAction(_ sender: AnyObject) {
       login_function()
    }

    // Variable
    private var ref: DatabaseReference!
    private var employees : [Employee] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start Listening
        
        start_queue()
        // Done Listening
        
        // Delegate
        email_uitext.delegate = self
        password_uitext.delegate = self
        
        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        

    }
    
    // Register Code
    func register_code() {
        let ref = Database.database().reference().child("Code")
        let Code : [ String : Any ] = [ "isUsed" : false,
                                       "Code_Type" : "SuperAdmin",
                                       "Company" : "" ]
        
        ref.child("12345").setValue(Code)
        ref.child("67890").setValue(Code)
      //  ref.child("12345").child("isUsed").setValue(true)

    }
    
    
    // Keyboard Delegate
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
    
    // Function: start_queue -> Void
    func start_queue(){
        
        let ref = Database.database().reference(withPath: "System_user")
        employees.removeAll()

        ref.observe(.value, with: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                        let employee : Employee = Employee.init( snapshot : snap)!
                        self.employees.append(employee)
                    }
                }
        })
    }
    
    // Function: isUserFound -> Bool
    func isUserFound() -> Bool {
        let uid : String = (Auth.auth().currentUser?.uid)!
        for items in employees{
            if items.UID == uid {
                return true
            }
        }
        return false
    }
    
    
    // Function: Login Function -> Void
    func login_function(){
        
        if ( self.email_uitext.text?.isEmpty )!  {
            
            let alert = UIAlertController(title: "", message: "Please enter your email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } // if Email_Empty
            
        else if ( self.password_uitext.text?.isEmpty )! {
            
            let alert = UIAlertController(title: "", message: "Please enter your password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } // if Password_Empty
        else {
            Auth.auth().signIn(withEmail: self.email_uitext.text!, password: self.password_uitext.text!) { (user, error) in
                
                if error == nil {

                    if ( self.isUserFound() ){
                        let sb = UIStoryboard ( name : "MainController" , bundle : nil)
                        let vc = sb.instantiateViewController(withIdentifier: "Home")
                        self.present(vc, animated: true, completion: nil)

                    }else {
                        let sb = UIStoryboard( name : "Welcome" , bundle : nil)
                        let vc = sb.instantiateViewController(withIdentifier: "Welcome_main")
                        self.present(vc, animated: true, completion: nil)
                    }
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            } // Login
        } // If login with username and password
    } // func
    
}

