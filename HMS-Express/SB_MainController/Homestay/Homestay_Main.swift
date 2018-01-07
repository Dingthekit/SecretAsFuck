//
//  Homestay_Main.swift
//  HMS-Express
//
//  Created by Ding Zhan on 30/12/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//


import UIKit
import Firebase


class Homestay_Main: UITableViewController {

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

        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        // DequeueHomestay
        self.start_queue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofhomestay.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "homestay", for: indexPath) as! Homestay_TableViewCell
        
        var curr_home: Homestay_schema1
        curr_home = listofhomestay[indexPath.row]
        cell.homestay_label.text = curr_home.get_name()
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "to_calender", sender: self)
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
    
    func dequeueHomestay() {
        //observing the data changes
        
        let ref_Homestay = Database.database().reference().child("Homestay").child(self.curruser.get_CID());
        ref_Homestay.observe(DataEventType.value, with: { (snapshot) in
            
            let total = snapshot.childrenCount
            var counter = 0
            if snapshot.childrenCount > 0 {
                
                self.listofhomestay.removeAll()
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    for item in snap.children.allObjects as! [DataSnapshot] {
                        if item.key == "HMI_1"{
                            //print(item)
                            let homestay = Homestay_schema1(snapshot: item)!
                            self.listofhomestay.append(homestay)
                            counter += 1
                            if ( counter == total ) {
                                self.removeLoadingScreen()
                                self.HomestayTable.reloadData()
                            }
                        }
                    }
                }
                
                //reloading the TableViewCell
                self.HomestayTable.reloadData()
            } else {
                self.removeLoadingScreen()
                self.HomestayTable.reloadData()
            }
        })
    }
    
    // start_queue for user information
    func start_queue(){
        let ref = Database.database().reference(withPath: "System_User")
        let uid : String = (Auth.auth().currentUser?.uid)!
        //self.setLoadingScreen()
        ref.child(uid).observe(.value, with: { snapshot in
            if snapshot.exists(){
                self.curruser = Employee.init(snapshot: snapshot)!
                self.dequeueHomestay()
            }
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        self.setNeedsStatusBarAppearanceUpdate()
        return .lightContent
    }



}
