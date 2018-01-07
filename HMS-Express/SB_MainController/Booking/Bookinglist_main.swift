//
//  bookinglist_detail.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

class bookinglist_detail: UITableViewController {

    
    private var listofbooking = [Booking]()
    private var listofcurrentweekbooking = [Booking]()
    private var listofnextweekbooking = [Booking]()
    private var listofpastbooking = [Booking]()
    private var listofafterrweekbooking = [Booking]()
    private var listofcustomer = [Customer]()
    private var listofhomestay = [Homestay_schema1]()

    private var curruser = Employee()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = " dd MMM "
        return formatter
    }()

    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()

    // IBOutlet
    @IBOutlet weak var Booking_Segmented: UISegmentedControl!
    @IBOutlet weak var BookingTable: UITableView!
    
    @IBAction func toggle_type(_ sender: UISegmentedControl) {
        self.Booking_Segmented.changeUnderlinePosition()
        self.BookingTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "to_information" {
            let indexPath:NSIndexPath = self.BookingTable.indexPathForSelectedRow! as NSIndexPath
            var booking_info = Booking()
            
            if self.Booking_Segmented.selectedSegmentIndex == 0 {
                if indexPath.section == 0 {
                    booking_info = self.listofcurrentweekbooking[indexPath.row]
                } else if indexPath.section == 1 {
                    booking_info = self.listofnextweekbooking[indexPath.row]
                } else {
                    booking_info = self.listofafterrweekbooking[indexPath.row]
                }
            } else {
                booking_info = self.listofpastbooking[indexPath.row]
            }
            
            let vc = segue.destination as! Bookinglist_information
            vc.booking_info = booking_info

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        setLoadingScreen()
        self.start_queue()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.load_booking()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.removeLoadingScreen()
                self.filter_date()
            }
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Booking_Segmented.addUnderlineForSelectedSegment()

        self.navigationController?.navigationBar.barStyle = .blackTranslucent

        
        /*
        setLoadingScreen()
        self.start_queue()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.load_booking()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.removeLoadingScreen()
                self.filter_date()
            }
        }*/

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Table View Delegate
    override func tableView( _ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if  self.Booking_Segmented.selectedSegmentIndex == 0 {
            if section == 0 {
                return "This week"
            } else if section == 1 {
                return "Next week"
            } else {
                return "Following week"
            }
        } else {
            return nil
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if  self.Booking_Segmented.selectedSegmentIndex == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.Booking_Segmented.selectedSegmentIndex == 0 {
            if section == 0 {
                return listofcurrentweekbooking.count
            } else if section == 1 {
                return listofnextweekbooking.count
            } else {
                return listofafterrweekbooking.count
            }
        } else {
            return listofpastbooking.count
        }

        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "booking_cell", for: indexPath) as! Booking_cell
        cell.updateUI()
        var curr_booking = Booking()
        
        if  self.Booking_Segmented.selectedSegmentIndex == 0 {
            if indexPath.section == 0 {
                curr_booking = listofcurrentweekbooking[indexPath.row]
            } else if indexPath.section == 1 {
                curr_booking = listofnextweekbooking[indexPath.row]
            } else if indexPath.section == 2 {
                curr_booking = listofafterrweekbooking[indexPath.row]
            }
        } else {
            curr_booking = listofpastbooking[indexPath.row]
        }

        
        let checkindate  = self.formatter.date( from : curr_booking.get_checkindate() )
        let checkoutdate = self.formatter.date( from : curr_booking.get_checkoutdate() )
        
        cell.checkin_date = checkindate!
        cell.checkout_date = checkoutdate!
        cell.homestay_name.text = curr_booking.get_hname()
        cell.customer_name.text = curr_booking.get_uname()
        cell.price.text = curr_booking.get_totalprice()

        cell.updateUI()
        cell.updateDate()
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.listofbooking.remove(at: indexPath.item)
            self.BookingTable.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    

    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.BookingTable.frame.width / 2) - (width / 2)
        let y = (self.BookingTable.frame.height / 2) - (height / 2)
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
        
    }
    
    private func load_booking() {
        //observing the data changes
        
        if (self.curruser.get_CID().isEmpty){   return  }
        
        let ref_Homestay = Database.database().reference().child("Booking").child(self.curruser.get_CID());
        
        ref_Homestay.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                // Clearing the list
                self.listofbooking.removeAll()
                self.listofpastbooking.removeAll()
                self.listofnextweekbooking.removeAll()
                self.listofafterrweekbooking.removeAll()
                self.listofcurrentweekbooking.removeAll()
                
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                            let booking = Booking(snapshot: snap)!
                            self.listofbooking.append(booking)
                            self.listofbooking.sort { (Booking1, Booking2) -> Bool in
                                if self.formatter.date(from: Booking1.get_checkindate())!  == self.formatter.date(from: Booking2.get_checkindate())!{
                                    return self.formatter.date(from: Booking1.get_checkoutdate())! < self.formatter.date(from: Booking2.get_checkoutdate())!
                                }else {
                                    return self.formatter.date(from: Booking1.get_checkindate())! < self.formatter.date(from: Booking2.get_checkindate())!
                                }

                            }
                    }
                }
                self.BookingTable.reloadData()
        })
        

    }
    
    // start_queue for user information
    private func start_queue(){
        let ref = Database.database().reference(withPath: "System_User")
        let uid : String = (Auth.auth().currentUser?.uid)!
        
        ref.child(uid).observe(.value, with: { snapshot in
            if snapshot.exists(){
                self.curruser = Employee.init(snapshot: snapshot)!
            }
        })
    }
    
    func get_nextweek() -> Date {
        var today_date = Date()
        today_date = self.formatter.date(from: self.formatter.string(from: today_date) )!
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let week : Double = 60*60*24*7
        if formatter.string(from: today_date) == "Mon" {
            return today_date.addingTimeInterval(60*60*24*(6) + week)
        } else if formatter.string(from: today_date) == "Tue" {
            return today_date.addingTimeInterval(60*60*24*(5) + week)
        } else if formatter.string(from: today_date) == "Wed" {
            return today_date.addingTimeInterval(60*60*24*(4) + week)
        } else if formatter.string(from: today_date) == "Thu" {
            return today_date.addingTimeInterval(60*60*24*(3) + week)
        } else if formatter.string(from: today_date) == "Fri" {
            return today_date.addingTimeInterval(60*60*24*(2) + week)
        } else if formatter.string(from: today_date) == "Sat" {
            return today_date.addingTimeInterval(60*60*24*1 + week)
        }  else {
            return today_date
        }
    }
    
    func get_lastday() -> Date {
        var today_date = Date()
        today_date = self.formatter.date(from: self.formatter.string(from: today_date) )!
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        if formatter.string(from: today_date) == "Mon" {
            return today_date.addingTimeInterval(60*60*24*(6))
        } else if formatter.string(from: today_date) == "Tue" {
            return today_date.addingTimeInterval(60*60*24*(5))
        } else if formatter.string(from: today_date) == "Wed" {
            return today_date.addingTimeInterval(60*60*24*(4))
        } else if formatter.string(from: today_date) == "Thu" {
            return today_date.addingTimeInterval(60*60*24*(3))
        } else if formatter.string(from: today_date) == "Fri" {
            return today_date.addingTimeInterval(60*60*24*(2))
        } else if formatter.string(from: today_date) == "Sat" {
            return today_date.addingTimeInterval(60*60*24*(1))
        }  else {
            return today_date
        }
    }
    
    func filter_date (){
        
        var today_date = Date()
        today_date = self.formatter.date(from: self.formatter.string(from: today_date) )!
        
        
        // filter pass_date first
        for booking in self.listofbooking {
            if self.formatter.date(from: booking.get_checkoutdate())! < today_date {
                self.listofpastbooking.append(booking)
            } else if self.formatter.date(from: booking.get_checkindate())! <= self.get_lastday() {
                self.listofcurrentweekbooking.append(booking)
            } else if self.formatter.date(from: booking.get_checkindate())! <= self.get_nextweek() {
                self.listofnextweekbooking.append(booking)
            } else {
                self.listofafterrweekbooking.append(booking)
            }
            
        }
        
        print("Past :" + String( self.listofpastbooking.count))
        print("curr :" + String(self.listofcurrentweekbooking.count))
        print("next :" + String(self.listofnextweekbooking.count))
        print("rest :" + String(self.listofafterrweekbooking.count))

        
        // Sort
        self.listofpastbooking.sort { (Booking1, Booking2) -> Bool in
            if self.formatter.date(from: Booking1.get_checkindate())!  == self.formatter.date(from: Booking2.get_checkindate())!{
                return self.formatter.date(from: Booking1.get_checkoutdate())! < self.formatter.date(from: Booking2.get_checkoutdate())!
            }else {
                return self.formatter.date(from: Booking1.get_checkindate())! < self.formatter.date(from: Booking2.get_checkindate())!
            }
            
        }
        
        self.listofcurrentweekbooking.sort { (Booking1, Booking2) -> Bool in
            if self.formatter.date(from: Booking1.get_checkindate())!  == self.formatter.date(from: Booking2.get_checkindate())!{
                return self.formatter.date(from: Booking1.get_checkoutdate())! < self.formatter.date(from: Booking2.get_checkoutdate())!
            }else {
                return self.formatter.date(from: Booking1.get_checkindate())! < self.formatter.date(from: Booking2.get_checkindate())!
            }
            
        }
        
        self.listofnextweekbooking.sort { (Booking1, Booking2) -> Bool in
            if self.formatter.date(from: Booking1.get_checkindate())!  == self.formatter.date(from: Booking2.get_checkindate())!{
                return self.formatter.date(from: Booking1.get_checkoutdate())! < self.formatter.date(from: Booking2.get_checkoutdate())!
            }else {
                return self.formatter.date(from: Booking1.get_checkindate())! < self.formatter.date(from: Booking2.get_checkindate())!
            }
            
        }
        
        self.listofafterrweekbooking.sort { (Booking1, Booking2) -> Bool in
            if self.formatter.date(from: Booking1.get_checkindate())!  == self.formatter.date(from: Booking2.get_checkindate())!{
                return self.formatter.date(from: Booking1.get_checkoutdate())! < self.formatter.date(from: Booking2.get_checkoutdate())!
            }else {
                return self.formatter.date(from: Booking1.get_checkindate())! < self.formatter.date(from: Booking2.get_checkindate())!
            }
            
        }
        self.BookingTable.reloadData()
        
    }
    
}
