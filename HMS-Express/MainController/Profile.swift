//
//  profile.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class profile: UITableViewController {
    
    // variable
    var postRef: DatabaseReference!
    private let ref = Database.database().reference(withPath: "System_User")
    private var curruser = Employee()
    
    // IBOutlet
    @IBOutlet var company_label : UILabel!
    @IBOutlet var first_name_label : UILabel!
    @IBOutlet var last_name_label : UILabel!
    @IBOutlet var email_label : UILabel!
    @IBOutlet var mobile_label : UILabel!
    
    @IBAction func logout(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let sb = UIStoryboard ( name : "Main" , bundle : nil )
                let vc = sb.instantiateInitialViewController()
                self.present(vc! , animated: true, completion: nil)

            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start Listening
        start_queue()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // Function: start_queue -> Void
    func start_queue(){
        
        let uid : String = (Auth.auth().currentUser?.uid)!
        ref.child(uid).observe(.value, with: { snapshot in
            if snapshot.exists(){
                self.curruser = Employee.init(snapshot: snapshot)!
                self.company_label.text =  self.curruser.get_CompName()
                self.email_label.text = self.curruser.get_email()
                self.first_name_label.text = self.curruser.get_firstname()
                self.last_name_label.text = self.curruser.get_lastname()
                self.mobile_label.text = self.curruser.get_phone()
                return
            }
        })
 
    }

}
