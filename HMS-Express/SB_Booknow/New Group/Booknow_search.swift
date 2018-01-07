//
//  booknow_search.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class booknow_search: UITableViewController {

    // Variable
    private var listofbooking = [ Booking ]()
    
    private var listoffullhomestay = [ String : AnyObject ]()
    private var listofhomestay = [ String ]()
    private var availablehomestay = [ String ]()
    private var not_availablehomestay = [ String ]()
    
    var checkin_date = Date()
    var checkout_date = Date()
    var checkin_childpax = String()
    var checkin_adultpax = String()
    
    private var curruser = Employee()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter
    }()
     
    fileprivate var animation_bool_listofbooking : Bool = false  {
        didSet {
            if animation_bool_listofbooking {
                self.seperate_list()
                if ( self.animation_bool_listofhomestay ) {
                    self.HomestayTable.reloadData()
                    self.removeLoadingScreen()
                }
            }
        }
    }
    
    fileprivate var animation_bool_listofhomestay : Bool = false  {
        didSet {
            if animation_bool_listofhomestay {
                self.seperate_list()
                if ( self.animation_bool_listofbooking ){
                    self.HomestayTable.reloadData()
                    self.removeLoadingScreen()
                }
            }
        }
    }
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
            
            var hid = String()
            if self.Homestay_Segmented.selectedSegmentIndex == 0 {
                hid = self.availablehomestay[indexPath.row]
            } else {
                hid = self.not_availablehomestay[indexPath.row]
            }
            
            vc.information = [ "checkin_date" : self.checkin_date ,
                               "checkout_date" : self.checkout_date,
                               "cid" : self.curruser.get_CID(),
                               "hid" : hid ] as [ String : Any ]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup_title()
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.Homestay_Segmented.addUnderlineForSelectedSegment()
        self.start_queue()
        
    }
    
    func setup_title(){
        var nights = String()
        if ( self.checkout_date.interval(ofComponent: .day, fromDate: self.checkin_date ) ==  1 ) {
            nights = " ( 1 Night )"
        } else {
            nights = " ( \( self.checkout_date.interval(ofComponent: .day, fromDate: self.checkin_date )) Nights )"
        }
        self.navigationItem.title = self.formatter2.string(from: self.checkin_date) + nights
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 16.0)!];
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
        
        var curr_home = String()
        if self.Homestay_Segmented.selectedSegmentIndex == 0 {
            curr_home = availablehomestay[indexPath.row]
        } else if self.Homestay_Segmented.selectedSegmentIndex == 1 {
            curr_home = not_availablehomestay[indexPath.row]
        }
        
        // setup_name
        
        let homestay_info = self.listoffullhomestay[ curr_home ] as! [ String : AnyObject ]

        let HMI_1 =  Homestay_schema1.init(listitem: (homestay_info["HMI_1"] as? [ String : String ])!)
        cell.homestay_label.text = HMI_1.get_name()
        cell.location.text = HMI_1.get_city() + ", " + HMI_1.get_state()
        cell.type.text = HMI_1.get_type()
        
        // Photo
        let images = homestay_info["Images"] as! [ String : String ]
        if let cover_image_url = images["IMG1"] {
            cell.photo.loadImageUsingCacheWithURlString(urlString: cover_image_url)
        }
        cell.photo.contentMode = .scaleAspectFill
        
        return cell
        
    }
    
    func seperate_list(){
        
        availablehomestay.removeAll()
        not_availablehomestay.removeAll()
        
        if listofbooking.isEmpty {
            availablehomestay = self.listofhomestay
            not_availablehomestay = []
        } else {
            for booking in listofbooking {
                if (( checkin_date < self.formatter.date(from: booking.get_checkoutdate())! ) &&
                    ( checkout_date > self.formatter.date(from: booking.get_checkindate())! ))  {
                    
                    for homestay in listofhomestay {
                        if homestay == booking.get_hid() && !not_availablehomestay.contains(homestay) {
                            not_availablehomestay.append(homestay)
                        }
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
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        self.HomestayTable.separatorStyle = .singleLine
    }
    

    func load_data() {
        //observing the data changes
        
        if (self.curruser.get_CID().isEmpty){   return  }
        self.setLoadingScreen()
        let ref_Homestay = Database.database().reference().child("Homestay").child(self.curruser.get_CID());
        let ref_Homestay2 = Database.database().reference().child("Booking").child(self.curruser.get_CID());

        ref_Homestay.observe(DataEventType.value, with: { (snapshot) in
            let total = snapshot.childrenCount
            var counter = 0

            if snapshot.childrenCount > 0 {
                self.listofhomestay.removeAll()
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    let key = snap.key
                    let value = snap.value as AnyObject
                    self.listofhomestay.append(key)
                    self.listoffullhomestay[key] = value
                    counter += 1
                    
                    if counter == total {
                        self.animation_bool_listofhomestay = true
                    }
                }
            } else {
                self.animation_bool_listofhomestay = true
            }
        })
        
        ref_Homestay2.observe(DataEventType.value, with: { (snapshot) in
            let total = snapshot.childrenCount
            var counter = 0

            if snapshot.childrenCount > 0 {
                self.listofbooking.removeAll()
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    let booking = Booking(snapshot: snap)!
                    self.listofbooking.append(booking)
                    counter += 1
                    if ( counter == total) {
                        self.animation_bool_listofbooking = true
                    }
                }
            } else {
                self.animation_bool_listofbooking = true
            }
        })
    }
    
    // start_queue for user information
    func start_queue(){
        let ref = Database.database().reference(withPath: "System_User")
        let uid : String = (Auth.auth().currentUser?.uid)!

        ref.child(uid).observe(.value, with: { snapshot in
            if snapshot.exists(){
                self.animation_bool_listofbooking = false
                self.animation_bool_listofhomestay = false
                self.curruser = Employee.init(snapshot: snapshot)!
                self.load_data()
            }
        })
    }
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}
