//
//  Welcome_host.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 23/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

class Welcome_host: UIViewController {

    // Variable
    var employee = [ String : String ]()
    fileprivate var data = [String : Any]()
    var code = String()
    fileprivate var info_employee = [ String ]()

    
    // IBOutlet
    @IBOutlet var Companyname_UItext: UITextField!

  
    // IBAction
    @IBAction func confirm_button(_ sender: AnyObject) {
        
        let company_name : String = Companyname_UItext.text!
        
        // If all field is filled
        if !( company_name.isEmpty ) {
 
            if ( isFound_Company(company_name) ){
                
                // Alert
                let alertController = UIAlertController(title: "", message: "This name has been used. Please retry" , preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
                
            } else {
                
                // Register Host Information
                let user_ref = Database.database().reference().child("System_user")
                let comp_ref = Database.database().reference().child("Company")
                let flagoff = Database.database().reference().child("Code")
                
                var user_uid = String()
                var user_email = String()
                var first_name = String()
                var last_name = String()
                var phonenumber = String()
                let privilage : String = "Admin"
                
                for ( itemkey, itemvalue ) in self.employee {
                    if(itemkey ==  "UID"){
                        user_uid = itemvalue as String
                    } else if (itemkey ==  "Email"){
                        user_email = itemvalue as String
                    } else if (itemkey ==  "First_Name"){
                        first_name = itemvalue as String
                    } else if (itemkey ==  "Last_Name"){
                        last_name = itemvalue as String
                    } else if (itemkey ==  "Phone_Number"){
                        phonenumber = itemvalue as String
                    }
                }
                
                let comp_key = Database.database().reference().child("System_User").childByAutoId().key

                let new_employee = [ "UID": user_uid,
                                     "Email": user_email ,
                                     "First_Name": first_name,
                                     "Last_Name": last_name ,
                                     "Phone_Number": phonenumber,
                                     "Privilage": privilage ,
                                     "CID" : comp_key,
                                     "Company_Name" : Companyname_UItext.text! ]
                
                
                let new_company = [ "CID" : comp_key,
                                    "Name" : company_name,
                                    "Host" : user_uid ]
                
                // Key for the Company
                comp_ref.child(comp_key).setValue(new_company)
                user_ref.child(user_uid).setValue(new_employee)
                
                // Control the things so that the user have to double confirm before that
                let alertController = UIAlertController(title: "", message: "Name can't be changed once confirmed!", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "Confirm!", style: .default , handler: { (action)-> Void in
                    
                    // Turn the flag off
                    flagoff.child(self.code).child("isUsed").setValue(true)
                    
                    // Navigate to the Controller
                    let sb = UIStoryboard( name : "MainController" , bundle : nil)
                    let vc = sb.instantiateViewController(withIdentifier: "Home")  as! UITabBarController
                    vc.selectedIndex = 0
                    self.present(vc, animated: true, completion: nil)
                    
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
                
            }
            
        // If the field is not filled
        } else {
            
            // Alert
            let alertController = UIAlertController(title: "", message: "Please enter the name of Company", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    // dequeue_Company : string -> void
    func dequeue_Company( _ code : String ){
        let ref = Database.database().reference(withPath: "Company")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if snap.key == code {
                        self.data = snap.value as! [String : Any]
                    }
                }
            }
        })
    }
    
    // isFound_Company : string -> Bool
    func isFound_Company( _ Comp_name : String ) -> Bool {
        for (datakey,datavalue) in self.data {
            if datakey == "Name" && ( (datavalue as! String) == Comp_name ){
                return true
            }
        }
        return false
    }
    
    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
