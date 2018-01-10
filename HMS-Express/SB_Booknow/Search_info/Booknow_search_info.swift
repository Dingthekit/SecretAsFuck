//
//  Booknow_search_info.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 07/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

class Booknow_search_info: UIViewController , UITableViewDelegate, UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource  {


    var information = [ String : Any ]()
    var listofimage : [ String ] = []
    var listofinfo = [ String ]()
    var listofdesc = [ String : String ]()
    var listofamenities = [ String ]()
    var listofamenities_desc = [ String : Bool ]()
    var homestay_information = [ String : AnyObject ]()
    var price = Int()
    
    var listofdate = [String]()
    var listofprice = [ String : String ]()
    var isPriceEntered : Bool = false
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy, EEE"
        return formatter
    }()
    let formatter_default: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // Outlet
    @IBOutlet var Gallery_Hide: UIImageView!
    @IBOutlet var Info_Hide: UIImageView!
    @IBOutlet var Price_Hide: UIImageView!
    @IBOutlet var Gallery_view: UIView!
    @IBOutlet var info_collection: UICollectionView!
    @IBOutlet weak var price_table : UITableView!
    @IBOutlet var Photo_collection_View: UIView!
    @IBOutlet var Information_View: UIView!
    @IBOutlet var Price_view: UIView!
    @IBOutlet var Photo_collection: UICollectionView!
    @IBOutlet var amenities: UICollectionView!
    @IBOutlet var price_height: NSLayoutConstraint!
    @IBOutlet var info_height: NSLayoutConstraint!
    @IBOutlet var apartmenttype: UILabel!
    @IBOutlet var add1: UILabel!
    @IBOutlet var add2: UILabel!
    @IBOutlet var add3: UILabel!
    
    @IBAction func Comfirm(_ sender: UIButton) {
        if self.isPriceEntered {
            let alert = UIAlertController(title: "", message: "One of the price has not entered. Please do the price setup in Homestay.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Comfirm", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "final_confirm", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "final_confirm" {
                let vc = segue.destination as! booknow_confirmation
                vc.information = self.information
                vc.homestay_information = self.homestay_information
                vc.price = self.price
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = min(self.view.bounds.size.height, self.price_table.contentSize.height)
        price_height.constant = height
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.price_table.delegate = self
        self.price_table.dataSource = self
        self.price_table.tag = 1

        self.info_collection.delegate = self
        self.info_collection.dataSource = self

        self.Photo_collection.delegate = self
        self.Photo_collection.dataSource = self
        
        self.amenities.delegate = self
        self.amenities.dataSource = self
        
        self.dequeue_info()
    }
    
    func setup_info(){
        
        // Information Setup
        self.navigationItem.title  = self.homestay_information["Name"] as? String
        
        // Total_Date Setup
        var calendarStartDate = self.information["checkin_date"]  as! Date
        let calendarEndDate = self.information["checkout_date"]  as! Date
        self.listofdate.append( self.formatter.string(from: calendarStartDate) )
        while( calendarStartDate < calendarEndDate ) {
            calendarStartDate = Calendar.current.date(byAdding: .day, value: 1, to: calendarStartDate)!
            self.listofdate.append( self.formatter.string(from: calendarStartDate) )
        }
        self.listofdate.removeLast()

        // Price Setup
        if let information_price : [ String : String ] = ( homestay_information["Prices"] as? [String : String]) {
            self.listofprice = information_price
            self.price_table.reloadData()
        } else {
            print("No prices")
            self.price_table.reloadData()
        }
        
        // Image Setup
        if let information_image : [ String : String ] = ( homestay_information["Images"] as? [String : String]) {
            for single in information_image {
                self.listofimage.append(single.value)
            }
        }
        self.Photo_collection.reloadData()


        // Information Setup
        if let information_hmi_1 : [ String : String ] = ( homestay_information["HMI_1"] as? [String : String]) {
            var PostalCode = ""
            var City = ""
            var State = ""

            for info in information_hmi_1 {
                if (info.key == "TypeOfHome") {
                    self.apartmenttype.text = info.value
                } else if ( info.key == "Address1") {
                    self.add1.text = info.value
                } else if ( info.key == "Address2") {
                    self.add2.text = info.value
                } else if ( info.key == "PostalCode") {
                    PostalCode = info.value
                } else if ( info.key == "City") {
                    City = info.value
                } else if ( info.key == "State") {
                    State = info.value
                }
            }
            
            self.add3.text = PostalCode + ", " + City + ", " + State
        }
        
        if let information_hmi_3 : [ String : Any ] = ( homestay_information["HMI_3"] as? [String : Any]) {
            
            for info in information_hmi_3 {
                if info.key != "HID" {
                    if info.value as! Bool {
                        self.listofamenities.append(info.key)
                    }
                }
            }
        }
        
        if let information_hmi_2 : [ String : String ] = ( homestay_information["HMI_2"] as? [String : String]) {
            print("Success")
            for info in information_hmi_2 {
                    if ( info.key == "Bathroom" ) {
                        self.listofdesc[ "Bath Room" ] = info.value
                    }
                    
                    if ( info.key == "SingleBed" ) {
                        self.listofdesc[ "Single Bed" ] = info.value
                    }
                    
                    if ( info.key == "Guest" ) {
                        self.listofdesc[ "Capacity" ] = info.value
                    }
                    
                    if ( info.key == "QueenBed" ) {
                        self.listofdesc[ "Queen Bed" ] = info.value
                    }
                    
                    if ( info.key == "KingBed" ) {
                        self.listofdesc[ "King Bed" ] = info.value
                    }
                    
                    if ( info.key == "Bedroom" ) {
                        self.listofdesc[ "Bedroom" ] = info.value
                    }
            }
            
            let listofsampleinfo = [ "Capacity" , "Bedroom" , "Bath Room" , "Single Bed",  "Queen Bed" , "King Bed" ]
            for info in listofsampleinfo {
                print()
                if !( ( self.listofdesc[info] == nil ) || ( self.listofdesc[info] == "0" || self.listofdesc[info] == "" ) ) {
                    self.listofinfo.append(info)
                }
            }
            self.info_collection.reloadData()
            self.amenities.reloadData()
        }
        
    }
  
    
    func dequeue_info() {
        //observing the data changes

        let ref_Homestay = Database.database().reference().child("Homestay").child(self.information["cid"] as! String).child(self.information["hid"] as! String)
        
        ref_Homestay.observe(DataEventType.value, with: { (snapshot) in

            if snapshot.exists() {

                let children = snapshot.children.allObjects as! [ DataSnapshot ]
                let total = children.count
                var counter = 0
                
                for snap in children {
                    let key = snap.key
                    let value = snap.value as AnyObject
                    self.homestay_information[key] = value
                    counter += 1

                    if counter == total {
                        self.setup_info()
                    }
                }
            } else {
                // Show Error
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
