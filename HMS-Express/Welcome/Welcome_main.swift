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

class Welcome_main: UIViewController, UITextFieldDelegate{
    
    // Variable
    var ref: DatabaseReference!
    let curruser = Auth.auth().currentUser
    let when = DispatchTime.now() + 10
    var listofcode = [[String : Any]]()
    var listofcode2 = [[String : Any]]()
    var counter = 1
    
    // IBOutlet
    @IBOutlet var firstname_uitext: UITextField!
    @IBOutlet var lastname_uitext: UITextField!
    @IBOutlet var mobile_uitext: UITextField!
    @IBOutlet var Code_UItext: UITextField!

    @IBAction func confirm_button(_ sender: AnyObject) {
        

        // If all field is filled
        if !( (firstname_uitext.text?.isEmpty)! || (lastname_uitext.text?.isEmpty)! || (mobile_uitext.text?.isEmpty)! || (Code_UItext.text?.isEmpty)!) {
            
            let user_email : String = curruser!.email!
            let first_name : String = firstname_uitext.text!
            let last_name : String = lastname_uitext.text!
            let phonenumber : String = mobile_uitext.text!
            let user_uid : String = (curruser?.uid)!
            
            let employee = ["UID": user_uid,
                            "email": user_email ,
                            "first_name": first_name,
                            "last_name": last_name ,
                            "phone_number": phonenumber,
                            "privilage": "staff" ]
            
            let code : String = Code_UItext.text!
            print("---Start---")
            
            self.dequeue_code(code)
            
            print(counter)
            print("---END---")
            counter += 1
        
            // Check if the code Valid
            printcode()
            if ( code_valid() ) {
                
                let curr_code_type : String = code_type()
                print("curr_code_type:")
                print(curr_code_type)
                
                // If code is SuperAdmin / Admin / Manager
                if( curr_code_type == "Staff" ) {
                    
                    // Register Employee Information
                    let ref = Database.database().reference().child("System_user")
                    let flagoff = Database.database().reference().child("Code")
                    
                    let employee = ["UID": user_uid,
                                    "email": user_email ,
                                    "first_name": first_name,
                                    "last_name": last_name ,
                                    "phone_number": phonenumber,
                                    "privilage": "" ,
                                    "Company_name" : code_company() ]
                    
                    
                    ref.child(user_uid).setValue(employee)
                    flagoff.child(Code_UItext.text!).child("isUsed").setValue(true)
                    let sb = UIStoryboard( name : "MainController" , bundle : nil)
                    let vc = sb.instantiateViewController(withIdentifier: "Home")  as! UITabBarController
                    vc.selectedIndex = 0
                    self.present(vc, animated: true, completion: nil)
                    
                }
                    
                // If code is SuperAdmin / Admin / Manager
                else if ( curr_code_type == "SuperAdmin" ||
                          curr_code_type == "Admin" ||
                          curr_code_type == "Manager") {
 
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome_host") as! Welcome_host
                    vc.employee = employee
                    vc.code = Code_UItext.text!
                    self.present(vc, animated: true, completion: nil)
                    
                }
                    
                // Codetype is not any of above
                else {
                    
                    // Alert
                    let alertController = UIAlertController(title: "", message: "The code enter is invalid.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    present(alertController, animated: true, completion: nil)
                }
                
            }
            // Code is invalid
            else{
                print("CODE WRONG")
                let alertController = UIAlertController(title: "", message: "The code enter is expired.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
            

        // If one of the field is not filled
        } else {
            
            // Alert
            let alertController = UIAlertController(title: "", message: "Please fill up all the information.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.printcode()
        }
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

    // Dequeue All Code
    func dequeue_code(_ code : String){
        print("Inner Dequeue start")

        let ref = Database.database().reference(withPath: "Code").child(code)
        var item =  [String : Any]()
        // self.listofcode2.removeAll()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for snap in snapshots as [DataSnat pshottt]{
                
                print(snap.key)
                /*
                if snapshot.exists() {
                    print(snapshot.key);
                    print(snapshot.value as! String);
                 
                     if snapshot.key == code {
                     item = snapshot.value as! [String : Any]
                     self.listofcode2.append(item)
                     }*/
                }
            }

            
        })
        print("Inner Dequeue Done")
    }
    
    // code_valid
    func code_valid() -> Bool {
        
        var result = Bool()
        for item in listofcode2{
            for (datakey,datavalue) in item {
                if datakey == "isUsed"{
                    result = !(datavalue as! Bool )
                }
            }
        }
        return result
    }
    
    // Print Code
    func printcode(){
        print("printcoderun")
        for item in listofcode2{
            for (datakey,datavalue) in item {
                    print(datakey)
                    print(datavalue)
            }
        }
    }

    func code_type() -> String {
        for item in listofcode2{

            for (datakey,datavalue) in item {
                if datakey == "Code_Type" {
                    return datavalue as! String
                }
            }}
        return ""
    }
    
    func code_company() -> String {
        for item in listofcode2{

        for (datakey,datavalue) in item {
            if datakey == "Company" {
                return datavalue as! String
            }
            }}
        return ""
    }
}

