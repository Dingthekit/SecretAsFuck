//
//  first_time_user.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 20/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import NVActivityIndicatorView


class Welcome_main: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable{
    
    // Variable
    fileprivate var ref: DatabaseReference!
    fileprivate let curruser = Auth.auth().currentUser
    fileprivate var listofcode = Code()
    fileprivate var sampleindicator : NVActivityIndicatorView = NVActivityIndicatorView(frame:  CGRect(x: UIScreen.main.bounds.size.width * 0.5 - 25 , y: UIScreen.main.bounds.size.height * 0.5 - 25, width: 50, height: 50), type: .ballRotateChase , color: UIColor.black , padding: CGFloat(0))
    
    
    // IBOutlet
    @IBOutlet var firstname_uitext: UITextField!
    @IBOutlet var lastname_uitext: UITextField!
    @IBOutlet var mobile_uitext: UITextField!
    @IBOutlet var Code_UItext: UITextField!

    
    // IBAction
    @IBAction func confirm_button(_ sender: AnyObject) {
        confirm_action()
    }
    
    // Back Button
    @IBAction func Back_button(_ sender: AnyObject) {
        let sb = UIStoryboard ( name : "Main" , bundle : nil)
        let vc = sb.instantiateViewController(withIdentifier: "Login")
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate
        firstname_uitext.delegate = self
        lastname_uitext.delegate = self
        mobile_uitext.delegate = self
        
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

    // Dequeue All Code
    func dequeue_code(_ code : String ){
        
        let ref = Database.database().reference(withPath: "Code").child(code)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                self.listofcode = Code.init(snapshot: snapshot)!
                return
                
            }})
    }
    
    // @Confirm_button
    func confirm_action(){
        
        
        // If all field is filled
        if !( (firstname_uitext.text?.isEmpty)! || (lastname_uitext.text?.isEmpty)! || (mobile_uitext.text?.isEmpty)! || (Code_UItext.text?.isEmpty)!) {
            
            let user_email : String = curruser!.email!
            let first_name : String = firstname_uitext.text!
            let last_name : String = lastname_uitext.text!
            let phonenumber : String = mobile_uitext.text!
            let user_uid : String = (curruser?.uid)!
            
            let employee = ["UID": user_uid,
                            "Email": user_email ,
                            "First_Name": first_name,
                            "Last_Name": last_name ,
                            "Phone_Number": phonenumber,
                            "Privilage": "Staff" ]
            
            let code : String = Code_UItext.text!
            
            self.dequeue_code(code)
            
            let blurEffect = UIBlurEffect(style: .dark )
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.frame
            
            self.sampleindicator.startAnimating()
            self.view.insertSubview(blurEffectView, at: 0)
            self.view.addSubview(self.sampleindicator)
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                
                self.sampleindicator.stopAnimating()
                self.view.subviews[0].removeFromSuperview()
                UIApplication.shared.endIgnoringInteractionEvents()

                if ( self.listofcode.get_validation() ) {
                    
                    let curr_code_type : String = self.listofcode.get_CompPermit()
                    
                    // If code is Staff / Manager
                    if( curr_code_type == "Staff" || curr_code_type == "Manager") {
                        
                        // Register Employee Information
                        let ref = Database.database().reference().child("System_User")
                        let flagoff = Database.database().reference().child("Code")
                        
                        let employee = Employee(user_uid, user_email ,first_name, last_name, phonenumber,
                        self.listofcode.get_CID() , self.listofcode.get_CompName() , curr_code_type )

                        ref.child(user_uid).setValue(employee.convert_to_list())
                        flagoff.child(self.Code_UItext.text!).child("isUsed").setValue(true)
                        let sb = UIStoryboard( name : "MainController" , bundle : nil)
                        let vc = sb.instantiateViewController(withIdentifier: "Home")  as! UITabBarController
                        vc.selectedIndex = 0
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                        
                    // If code is SuperAdmin / Admin
                    else if ( curr_code_type == "SuperAdmin" ||
                              curr_code_type == "Admin" ) {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome_host") as! Welcome_host
                        vc.employee = employee
                        vc.code = self.Code_UItext.text!
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                        
                    // Codetype is not any of above
                    else {
                        
                        // Alert
                        let alertController = UIAlertController(title: "", message: "The code enter is invalid.", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }
                
                // Code is invalid
                else{
                    let alertController = UIAlertController(title: "", message: "The code enter is expired.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        // If any of field is not filled
        } else {
            
            let alertController = UIAlertController(title: "", message: "Please fill up all the information.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    } // End Function

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

