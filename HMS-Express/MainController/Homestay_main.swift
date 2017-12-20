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
    fileprivate var listofhomestay = [Homestay_schema1]()
    fileprivate var homestay_name = String()
    fileprivate var curruser = Employee()
    @IBOutlet weak var HomestayTable: UITableView!
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    // Register Button
    @IBAction func register_button(_ sender: AnyObject) {
        let sb = UIStoryboard( name : "Homestay", bundle : nil )
        let vc = sb.instantiateViewController(withIdentifier: "Homestay_info_VC")
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "to_calender" {
            let indexPath:NSIndexPath = self.HomestayTable.indexPathForSelectedRow! as NSIndexPath
            let sb = UIStoryboard( name : "Calendar", bundle : nil )
            let vc = sb.instantiateViewController(withIdentifier: "Calender_price") as! Price_homestay
            vc.company_id = self.curruser.get_CID()
            vc.homestay_id = self.listofhomestay[indexPath.row].get_hid()
            vc.homestay_name = self.listofhomestay[indexPath.row].get_name()
            
            let vc_nc = segue.destination as! UINavigationController
            vc_nc.viewControllers[0] = vc
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DequeueHomestay
        self.start_queue()
        self.setLoadingScreen()
        //self.navigationController?.statu = .lightContent
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.dequeueHomestay()
            self.removeLoadingScreen()
        }
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
        
        return cell
        
    }
    

    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        self.HomestayTable.separatorStyle = .none

        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.HomestayTable.frame.width / 2) - (width / 2)
        let y = (self.HomestayTable.frame.height / 2) - (height / 2)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        self.HomestayTable.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
        self.HomestayTable.separatorStyle = .singleLine

    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "to_calender", sender: self)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
