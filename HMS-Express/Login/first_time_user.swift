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

class first_time_user: UIViewController, UITextFieldDelegate{
    
    // Variable
    var ref: DatabaseReference!
    private let curruser = Auth.auth().currentUser
    var listofemployee = [Employee]()

    // IBOutlet
    @IBOutlet var firstname_uitext: UITextField!
    @IBOutlet var lastname_uitext: UITextField!
    @IBOutlet var mobile_uitext: UITextField!

    @IBAction func confirm_button(_ sender: AnyObject) {

        //let childUpdates = ["/": User]
        if !( (firstname_uitext.text?.isEmpty)! || (lastname_uitext.text?.isEmpty)! || (mobile_uitext.text?.isEmpty)! ) {
            addCompany()
        } else {
            
            // alert
            let alertController = UIAlertController(title: "", message: "Please fill up all the information.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }
        let sb = UIStoryboard ( name : "MainController" , bundle : nil)
        let vc = sb.instantiateViewController(withIdentifier: "Home")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // Add Company
    func addCompany(){
        

        let user_email : String = curruser!.email!
        let first_name : String = firstname_uitext.text!
        let last_name : String = lastname_uitext.text!
        let phonenumber : String = mobile_uitext.text!
        let user_uid : String = (curruser?.uid)!
        
        // Need to find the Homestay_Company_Name
        
        let ref = Database.database().reference().child("System_user")
        
        let Employee = ["UID": user_uid,
                        "email": user_email ,
                        "first_name": first_name,
                        "last_name": last_name ,
                        "phone_number": phonenumber,
                        "privilage": "" ]
        
        ref.child(user_uid).setValue(Employee)

    }
}
