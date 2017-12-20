//
//  Booknow_search_info.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 07/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

class Booknow_search_info: UIViewController , UITableViewDelegate, UITableViewDataSource {

    // Variable
    var homestay_ID = String()
    var homestay = Homestay_schema1()

    var checkin_date = Date()
    var checkout_date = Date()
    var company_id = String()
    var homestay_id = String()
    var fulladdress = String()
    var price = Int()
    var listofdate = [String]()
    var listofprice = [ String : String ]()
    fileprivate var isPriceEntered : Bool = false
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yy ( EEE )"
        return formatter
    }()
    fileprivate let formatter_default: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    // Outlet
    @IBOutlet weak var price_table : UITableView!

    @IBOutlet weak var full_address: UILabel!
    
    
    @IBAction func Comfirm(_ sender: UIButton) {
        if self.isPriceEntered {
            
            let alert = UIAlertController(title: "", message: "One of the price has not entered. Please do the price setup in Homestay.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Comfirm", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            self.performSegue(withIdentifier: "to_customer", sender: self)
        }
        
    }
    // segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "to_customer" {
        
                let vc = segue.destination as! booknow_customerinfo
                vc.checkin_date = self.checkin_date
                vc.checkout_date = self.checkout_date
                vc.company_id = self.company_id
                vc.homestay_id = self.homestay_id
                vc.homestay = self.homestay
                vc.price = self.price
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        price_table.delegate = self
        price_table.dataSource = self
        
        self.navigationItem.title = self.homestay.get_name()
        self.full_address.text = homestay.get_add1() + ", " + homestay.get_add2() + ", " + homestay.get_pos() + ", " + homestay.get_city() + ", " +  homestay.get_state()
        self.setLoadingScreen()
        self.dequeueprice()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.setup_price()
            self.price_table.reloadData()
            self.removeLoadingScreen()
        }
        
        
    }
    
    func setup_price(){
        
        var currentDate = self.checkin_date
        let calendarEndDate = self.checkout_date
        self.listofdate.append(self.formatter.string(from: currentDate).uppercased())
        while(currentDate < calendarEndDate) {
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            self.listofdate.append(self.formatter.string(from: currentDate).uppercased())
        }
        self.listofdate.removeLast()

    }
    
    // Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listofdate.count == 0 {
            return 0
        } else {
            return ( listofdate.count + 1 )
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ( indexPath.row != listofdate.count ) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "single_price", for: indexPath) as! single_price_cell
            
            cell.price_date.text = self.listofdate[indexPath.row]
            
            for price in listofprice {
                if formatter.date(from: self.listofdate[indexPath.row]) == formatter_default.date(from: price.key) {
                    cell.price.text = String(price.value) + " MYR"
                }
            }
            
            if (cell.price.text?.isEmpty)! {
                self.isPriceEntered = true
                cell.price.text = "0" + " MYR"
            }
            
            return cell
       }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "total_price", for: indexPath) as! total_price_cell
            
            
            var total : Int = 0
            for price in listofprice {
                for date in listofdate{
                    if formatter.date(from: date) == formatter_default.date(from: price.key) {
                        total += Int(price.value)!

                    }
                }
                
            }
            self.price = total
            cell.price.text = String(total) + " MYR"
            
            return cell
        }

        
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        self.price_table.separatorStyle = .none

        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.price_table.frame.width / 2) - (width / 2)
        let y = (self.price_table.frame.height / 2) - (height / 2)
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
        
        self.price_table.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
                
    }

    
    func dequeueprice() {
        //observing the data changes

        let ref_Homestay = Database.database().reference().child("Homestay").child(self.company_id).child(self.homestay_id).child("Price")
        
        ref_Homestay.observeSingleEvent(of: DataEventType.value , with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                // Clearing the list
                self.listofprice.removeAll()
                print(snapshot)
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    let date = snap.key
                    let price = snap.value as! String
                    self.listofprice[date] = price
                }
            }
        })
        
    }
    
    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
