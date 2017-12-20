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
    private var listofhomestay = [Homestay_schema1]()
    private var listofbooking = [Booking]()
    private var availablehomestay = [Homestay_schema1]()
    private var not_availablehomestay = [Homestay_schema1]()
    var checkin_date = Date()
    var checkout_date = Date()
    private var curruser = Employee()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
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
    
    @IBAction func toggle_type(_ sender: UISegmentedControl) {
        seperate_list()
        self.Homestay_Segmented.changeUnderlinePosition()
        
        if self.Homestay_Segmented.selectedSegmentIndex == 1 {
            self.HomestayTable.allowsSelection = false
        } else {
            self.HomestayTable.allowsSelection = true
        }
        self.HomestayTable.reloadData()

    }
    
    //prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "to_detail" {
            let indexPath:NSIndexPath = self.HomestayTable.indexPathForSelectedRow! as NSIndexPath
            let vc = segue.destination as! Booknow_search_info
            var homestay_item = Homestay_schema1()

            
            if self.Homestay_Segmented.selectedSegmentIndex == 0 {
                homestay_item = availablehomestay[indexPath.row]
                vc.homestay_id = self.availablehomestay[indexPath.row].get_hid()

            } else {
                homestay_item = not_availablehomestay[indexPath.row]
                vc.homestay_id = self.not_availablehomestay[indexPath.row].get_hid()

            }
            
            vc.homestay = homestay_item
            vc.checkin_date = self.checkin_date
            vc.checkout_date = self.checkout_date
            vc.company_id = self.curruser.get_CID()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.Homestay_Segmented.addUnderlineForSelectedSegment()
        print(checkin_date)
        
        // DequeueHomestay
        self.start_queue()
        self.setLoadingScreen()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.load_homestay()
            self.load_booking()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.seperate_list()
                self.HomestayTable.reloadData()
                self.removeLoadingScreen()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Homestay_Segmented.selectedSegmentIndex == 1 {
            return not_availablehomestay.count
        }
        
        return availablehomestay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "book_cell", for: indexPath) as! Booknow_cell
        
        var curr_home = Homestay_schema1()
        if self.Homestay_Segmented.selectedSegmentIndex == 0 {
            curr_home = availablehomestay[indexPath.row]
        } else if self.Homestay_Segmented.selectedSegmentIndex == 1 {
            curr_home = not_availablehomestay[indexPath.row]
        }
        
        cell.homestay_label.text = curr_home.get_name()
        
        return cell
        
    }
    
    func seperate_list(){
        availablehomestay.removeAll()
        not_availablehomestay.removeAll()
        
        for booking in listofbooking {
            if (( checkin_date < self.formatter.date(from: booking.get_checkoutdate())! ) &&
                ( checkout_date > self.formatter.date(from: booking.get_checkindate())! ))  {
                
                for homestay in listofhomestay {
                    if homestay.get_hid() == booking.get_hid() && !not_availablehomestay.contains(homestay) {
                        not_availablehomestay.append(homestay)
                    }
                }
                
            }
        }
        availablehomestay = Array(Set(listofhomestay).subtracting(Set(not_availablehomestay)))
        self.HomestayTable.reloadData()

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
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
        self.HomestayTable.separatorStyle = .singleLine

    }
    

    func load_homestay() {
        //observing the data changes
        
        if (self.curruser.get_CID().isEmpty){   return  }
        
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
                
                self.HomestayTable.reloadData()
            }
        })
    }
    
    private func load_booking() {
        //observing the data changes
        
        if (self.curruser.get_CID().isEmpty){   return  }
        
        let ref_Homestay = Database.database().reference().child("Booking").child(self.curruser.get_CID());
        
        ref_Homestay.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                // Clearing the list
                self.listofbooking.removeAll()
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    let booking = Booking(snapshot: snap)!
                    self.listofbooking.append(booking)
                }
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
