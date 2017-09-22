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
                let vc = sb.instantiateViewController(withIdentifier: "Login")
                self.present(vc , animated: true, completion: nil)

            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    
    // variable
    var postRef: DatabaseReference!
    let ref = Database.database().reference(withPath: "System_user")
    private var curruser : Employee = Employee.init()
    
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
        let ref = Database.database().reference(withPath: "System_user")
        let uid : String = (Auth.auth().currentUser?.uid)!

        ref.observe(.value, with: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshots {
                    if snap.key == uid{
                        let employee : Employee = Employee.init( snapshot : snap)!
                        self.curruser = employee

                        self.first_name_label.text = employee.first_name
                        self.last_name_label.text = employee.last_name
                        self.email_label.text = employee.email
                        self.mobile_label.text = employee.phonenumber
                        break
                    }
                }
            }
        })
    }

}
