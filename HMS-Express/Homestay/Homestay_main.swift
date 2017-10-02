//
//  Homestay_main.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 22/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//
 
import UIKit
import Firebase

class Homestay_main: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Variable
    var listofhomestay = [Homestay_schema1]()
    private var curruser = Employee()
    @IBOutlet weak var HomestayTable: UITableView!
    
    // Register Button
    @IBAction func register_button(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homestay_info_page1") as! Homestay_info_page1
        vc.homestay_info_1 = Homestay_schema1.init()
        vc.homestay_info_2 = Homestay_schema2.init()
        vc.homestay_info_3 = Homestay_schema3.init()

        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DequeueHomestay
        self.start_queue()

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.dequeueHomestay()
        }
        
        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

    
    // Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofhomestay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "homestay", for: indexPath) as! Homestay_TableViewCell
        
        var curr_home: Homestay_schema1
        curr_home = listofhomestay[indexPath.row]
        cell.homestay_label.text = curr_home.get_name()
        cell.location_label.text = curr_home.get_Location()
        
        return cell
        
    }
    
    func dequeueHomestay() {
        //observing the data changes
        
        if (self.curruser.get_CID().isEmpty){
            print("Empty")
            return
        }
        
        let ref_Homestay = Database.database().reference().child("Homestay").child(self.curruser.get_CID());

        ref_Homestay.observe(DataEventType.value, with: { (snapshot) in
            
            let homestay = Homestay_schema1()
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                // Clearing the list
                self.listofhomestay.removeAll()
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    for item in snap.children.allObjects as! [DataSnapshot] {
                        if item.key == "HMI_1"{
                            //print(item)
                            let homestay = Homestay_schema1(snapshot: item)!
                            self.listofhomestay.append(homestay)
                        }
                    }

                }
                
                //reloading the TableViewCell
                self.HomestayTable.reloadData()
            }
        })
    }

    // start_queue for user information
    func start_queue(){
        let ref = Database.database().reference(withPath: "System_User")
        let uid : String = (Auth.auth().currentUser?.uid)!
        
        ref.child(uid).observe(.value, with: { snapshot in
            if snapshot.exists(){
                self.curruser = Employee.init(snapshot: snapshot)!
                print("GOT IT: " + self.curruser.get_CID())
            }
        })
    }
}
