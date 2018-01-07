//
//  Welcome_host.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 23/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class Welcome_host: UIViewController {

    // Variable
    var employee = Employee()
    var code = String()
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
    
    fileprivate var isFoundCompany = Bool() {
        didSet {
            if isFoundCompany {
                animation_bool = false
                let alertController = UIAlertController(title: "", message: "This name has been used. Please retry" , preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
            else {
                // Register Host Information
                animation_bool = false
                let user_ref = Database.database().reference().child("System_User")
                let comp_ref = Database.database().reference().child("Company")
                let flagoff = Database.database().reference().child("Code")
                let comp_key = Database.database().reference().child("System_User").childByAutoId().key
                employee.set_Compname(Companyname_UItext.text!)
                employee.set_privi("Admin")
                employee.set_CID(comp_key)
                let new_company = [ "CID" : comp_key, "Name" : Companyname_UItext.text! , "Host" : employee.get_UID() ]
                
                // Control the things so that the user have to double confirm before that
                let alertController = UIAlertController(title: "", message: "Name can't be changed once confirmed!", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Confirm!", style: .default , handler: { (action)-> Void in
                    
                    // Turn the flag off
                    flagoff.child(self.code).child("isUsed").setValue(true)
                    comp_ref.child(comp_key).setValue(new_company)
                    user_ref.child(self.employee.get_UID()).setValue(self.employee.convert_to_list())
                    
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
        }
    }
    fileprivate var info_employee = [ String ]()
    @IBOutlet var Companyname_UItext: UITextField!

    // IBAction
    @IBAction func confirm_button(_ sender: AnyObject) {
        
        let company_name : String = Companyname_UItext.text!
        
        // If all field is filled
        if ( !company_name.isEmpty ) {
            self.animation_bool = true
            self.dequeue_Company(self.code)
        } else {
            let alertController = UIAlertController(title: "", message: "Please enter the name of Company", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Companyname_UItext.useUnderLine()
        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    // dequeue_Company : string -> void
    func dequeue_Company( _ name : String ){
        let ref = Database.database().reference(withPath: "Company")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                let item_count = snapshot.childrenCount
                if ( item_count == 0) {
                    self.isFoundCompany = false
                }
                var counter = 0
                for snap in snapshots {
                    if snap.key == name {
                        self.isFoundCompany = true
                    }
                    counter += 1
                    if ( counter == item_count && !self.isFoundCompany ) {
                        self.isFoundCompany = false
                    }
                }
            }
        })
    }
    
    func textFieldDidBeginEditing( _ textField: UITextField ) {
        textField.useUnderLine_whileediting()
    }
    
    func textFieldDidEndEditing( _ textField: UITextField) {
        textField.useUnderLine()
    }
    
    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
