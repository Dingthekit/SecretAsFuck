//
//  booknow_search.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

class booknow_search: UITableViewController {

    // Variable
    var listofhomestay = [Homestay_schema1]()
    private var curruser = Employee()
    
    // IBOutlet
    @IBOutlet weak var Homestay_Segmented: UISegmentedControl!
    @IBOutlet weak var HomestayTable: UITableView!

    // IBAction
    @IBAction func back_button(_ sender: AnyObject) {
        let sb = UIStoryboard( name : "MainController", bundle : nil )
        let vc = sb.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 0
        self.present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "to_detail" {
            let indexPath:NSIndexPath = self.HomestayTable.indexPathForSelectedRow! as NSIndexPath
            let homestay_item : Homestay_schema1 = listofhomestay[indexPath.row]
            let vc = segue.destination as! Booknow_search_info
            vc.homestay = homestay_item.copy() as! Homestay_schema1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // DequeueHomestay
        self.start_queue()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.dequeueHomestay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofhomestay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "book_cell", for: indexPath) as! Booknow_cell
        
        var curr_home: Homestay_schema1
        curr_home = listofhomestay[indexPath.row]
        cell.homestay_label.text = curr_home.get_name()
        
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
            }
        })
    }
    
    

}
