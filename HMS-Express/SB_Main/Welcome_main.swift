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
    fileprivate var employee = Employee()
    fileprivate var sampleindicator : NVActivityIndicatorView = NVActivityIndicatorView(frame:  CGRect(x: UIScreen.main.bounds.size.width * 0.5 - 25 , y: UIScreen.main.bounds.size.height * 0.5 - 25, width: 50, height: 50), type: .ballRotateChase , color: UIColor.black , padding: CGFloat(0))
    
    fileprivate var animation_bool : Bool = false  {
        didSet {
            if animation_bool {
                self.sampleindicator.startAnimating()
                self.view.addSubview(self.sampleindicator)
            }
            else {
                self.sampleindicator.stopAnimating()
                self.view.subviews[self.view.subviews.capacity - 1].removeFromSuperview()
            }
        }
    }
    @IBOutlet var firstname_uitext: UITextField!
    @IBOutlet var lastname_uitext: UITextField!
    @IBOutlet var mobile_uitext: UITextField!
    @IBOutlet var Code_UItext: UITextField!

    // IBAction
    @IBAction func confirm_button(_ sender: AnyObject) {
        confirm_action()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "register_name" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome_host") as! Welcome_host
            vc.employee = employee
            vc.code = self.Code_UItext.text!
            self.present(vc, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate
        firstname_uitext.delegate = self
        firstname_uitext.useUnderLine()
        lastname_uitext.delegate = self
        lastname_uitext.useUnderLine()
        mobile_uitext.delegate = self
        mobile_uitext.useUnderLine()
        Code_UItext.delegate = self
        Code_UItext.useUnderLine()
        
        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldDidBeginEditing( _ textField: UITextField ) {
        textField.useUnderLine_whileediting()
    }
    
    func textFieldDidEndEditing( _ textField: UITextField) {
        textField.useUnderLine()
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
    private func dequeue_code(_ code : String ){
        
        self.animation_bool = true;
        let ref = Database.database().reference(withPath: "Code").child(code)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                self.listofcode = Code.init(snapshot: snapshot)!
                
                // if it is invalid
                if ( !self.listofcode.get_validation() ){
                    self.animation_bool = false
                    let alertController = UIAlertController(title: "", message: "The code enter has been used.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    
                    let curr_code_type : String = self.listofcode.get_CompPermit()
                    if( curr_code_type == "Staff" || curr_code_type == "Manager") {
                        
                        let ref = Database.database().reference().child("System_User")
                        let flagoff = Database.database().reference().child("Code")
                        self.employee.set_CID(self.listofcode.get_CID())
                        self.employee.set_privi(curr_code_type)
                        self.employee.set_Compname(self.listofcode.get_CompName())
                        
                        ref.child(self.employee.get_UID()).setValue(self.employee.convert_to_list())
                        flagoff.child(self.Code_UItext.text!).child("isUsed").setValue(true)
                        let sb = UIStoryboard( name : "MainController" , bundle : nil)
                        let vc = sb.instantiateViewController(withIdentifier: "Home")  as! UITabBarController
                        vc.selectedIndex = 0
                        self.present(vc, animated: true, completion: nil)
                    } else if ( curr_code_type == "SuperAdmin" || curr_code_type == "Admin" ) {
                        self.performSegue(withIdentifier: "register_name", sender: self)
                    }  else {
                        // Alert
                        self.animation_bool = false
                        let alertController = UIAlertController(title: "", message: "The code enter is invalid.", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            } else {
                // Alert
                self.animation_bool = false
                let alertController = UIAlertController(title: "", message: "The code enter is invalid.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    // @Confirm_button
    private func confirm_action(){
        
        // If all field is filled
        if !( (firstname_uitext.text?.isEmpty)! || (lastname_uitext.text?.isEmpty)! || (mobile_uitext.text?.isEmpty)! || (Code_UItext.text?.isEmpty)!) {
            self.animation_bool = true
            self.employee = Employee((curruser?.uid)!, curruser!.email! ,firstname_uitext.text!, lastname_uitext.text!, mobile_uitext.text!, "" , "" , "" )
            self.dequeue_code(Code_UItext.text!)
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



