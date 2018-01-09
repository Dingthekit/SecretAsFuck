//
//  booknow_main.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase

class booknow_main: UIViewController, UITextFieldDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance,  UICollectionViewDelegate , UICollectionViewDataSource  {

    
    
    // Subview IBOutlet
    var checkin_nsdate = NSDate()
    var checkout_nsdate = NSDate()
    fileprivate var curruser = Employee()
    var listofhomestay = [ AnyObject ]()
    @IBOutlet var sub_checkin_day: UILabel!
    @IBOutlet var sub_checkin_date: UILabel!
    @IBOutlet var sub_checkout_day: UILabel!
    @IBOutlet var sub_checkout_date: UILabel!
    let sub_formatter_day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    let sub_formatter_date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        return formatter
    }()
    
    @IBOutlet var Homestay_view: UICollectionView!
    @IBOutlet weak var done_button: UIButton!
    @IBOutlet var adult_label: UILabel!
    @IBOutlet var child_label: UILabel!
    let gregorian = Calendar(identifier: .gregorian)
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "  d MMM ( EEE )"
        return formatter
    }()
    private let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, YYYY, EEE"
        return formatter
    }()
    
    // SuperView IBOutlet
    @IBOutlet var samplesubview: UIView!
    @IBOutlet var Calender: FSCalendar!
    @IBOutlet var checkin_date: UIButton!
    @IBOutlet var checkout_date: UIButton!
    @IBOutlet var adult_minus_button: UIButton!
    @IBOutlet var child_minus_button: UIButton!
    
    // IBAction
    @IBAction func to_subview(_ sender: UIButton) {
        
        // Subview Setup
        self.done_button.backgroundColor?.withAlphaComponent(0.5)
        self.done_button.isEnabled = false
        self.navigationController?.isNavigationBarHidden = true
        // let height = self.navigationController?.navigationBar.fs_height
        self.samplesubview.frame = CGRect.init(x: 0, y: 20, width: (self.view.superview?.frame.size.width)! , height: (self.view.superview?.frame.size.height)! - 20 )

        self.view.superview?.addSubview(self.samplesubview)
        
        // Turn off button
        samplesubview.isHidden = false
        
        // Deselect All Date
        for selected_date in self.Calender.selectedDates{
            self.Calender.deselect(selected_date)
        }
        
        self.adult_label.text = "0"
        self.child_label.text = "0"

        self.sub_checkin_day.text = "Please Select Date"
        self.sub_checkin_date.text = " "
        self.sub_checkout_day.text = " "
        self.sub_checkout_date.text = ""


        // Hide Tab Bar
        self.tabBarController?.tabBar.isHidden = true
    }

    
    @IBAction func back_subview(_ sender: UIButton) {
        
        // Hide All Subviews
        samplesubview.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false

        // Update the Button
        self.checkin_date.setTitle(formatter2.string(from: self.Calender.selectedDates[0]), for: .normal)
        self.checkout_date.setTitle(formatter2.string(from: self.Calender.selectedDates.sorted()[self.Calender.selectedDates.count - 1]), for: .normal)
        
    }
    
    
    @IBAction func adult_add(_ sender: UIButton) {
        if ( adult_label.text! == "0") {
            self.adult_label.text = String(Int(adult_label.text!)! + 1)
            self.adult_minus_button.isHidden = false
        } else {
            self.adult_label.text = String(Int(adult_label.text!)! + 1)
        }
    }
    
    @IBAction func adult_minus(_ sender: UIButton) {
        if ( adult_label.text! == "1") {
            self.adult_label.text = String(Int(adult_label.text!)! - 1)
            sender.isHidden = true
        } else {
            self.adult_label.text = String(Int(adult_label.text!)! - 1)
        }
    }
    
    @IBAction func child_add(_ sender: UIButton) {
        if ( child_label.text! == "0") {
            self.child_label.text = String(Int(child_label.text!)! + 1)
            self.child_minus_button.isHidden = false
        } else {
            self.child_label.text = String(Int(child_label.text!)! + 1)
        }
    }
    
    @IBAction func child_minus(_ sender: UIButton) {
        if ( child_label.text! == "1") {
            self.child_label.text = String(Int(child_label.text!)! - 1)
            sender.isHidden = true
        } else {
            self.child_label.text = String(Int(child_label.text!)! - 1)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirm_date" {
            let sb = UIStoryboard( name : "Booknow", bundle : nil )
            let sub_vc = sb.instantiateViewController(withIdentifier: "booknow_search") as! booknow_search
            sub_vc.checkin_date = self.checkin_nsdate as Date
            sub_vc.checkout_date = self.checkout_nsdate as Date

            let vc = segue.destination as! UINavigationController
            vc.viewControllers[0] = sub_vc
        }
    }
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .blackTranslucent

        // Calender Delegate
        Calender.delegate = self
        Calender.dataSource = self
        calender_setup()
        self.start_queue()

        
        let dates = [ self.gregorian.date(byAdding: .day, value: 0, to: Date()),
                      self.gregorian.date(byAdding: .day, value: +1, to: Date()) ]
        dates.forEach { (date) in
            self.Calender.select(date, scrollToDate: false)
        }
        self.checkin_nsdate = self.Calender.selectedDates[0] as NSDate
        self.checkout_nsdate = self.Calender.selectedDates.sorted()[self.Calender.selectedDates.count - 1] as NSDate
        
        checkin_date.setTitle(formatter2.string(from: dates[0]!), for: .normal)
        checkout_date.setTitle(formatter2.string(from: dates[1]!), for: .normal)
 
        
    }
    
    func calender_setup(){
        self.Calender.scrollDirection = .vertical
        self.Calender.swipeToChooseGesture.isEnabled = true
        self.Calender.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
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
                    let value = snap.value as AnyObject
                    self.listofhomestay.append(value)
                    counter += 1
                    if counter == total {
                        // animation
                        self.Homestay_view.reloadData()
                    }
                }
            } else {
                // animation
            }
        })
        
    }
    
    // Function: start_queue -> Void
    func start_queue(){
        let uid : String = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference(withPath: "System_User")
        ref.child(uid).observe(.value, with: { snapshot in
            if snapshot.exists(){
                self.curruser = Employee.init(snapshot: snapshot)!
                self.dequeueHomestay()
            }
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


