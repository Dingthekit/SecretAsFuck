//
//  booknow_customerinfo.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

class booknow_customerinfo: UITableViewController, UISearchResultsUpdating , UISearchBarDelegate {

    // Variable
    var total_customer = [Customer]()
    var filter_customer = [Customer]()
    var checkin_date = Date()
    var checkout_date = Date()
    var company_id = String()
    var homestay_id = String()
    var homestay = Homestay_schema1()
    var price = Int()
    fileprivate var curruser = Employee()
    let searchController = UISearchController(searchResultsController: nil)

    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    // IBOutlet
    @IBOutlet var user_table: UITableView!

    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        print(self.company_id)
        print(self.homestay_id)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.init(red: 35/255, green: 59/255, blue: 77/255, alpha: 1)

        searchController.searchBar.isTranslucent = false
        user_table.tableHeaderView = searchController.searchBar
        self.searchController.searchBar.delegate = self
        definesPresentationContext = true

        
        self.start_queue()
        self.setLoadingScreen()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dequeueHomestay()
            self.removeLoadingScreen()
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // MARK : UISearch Protocol
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "to_comfirm" {
            
            let index : Int = (self.user_table.indexPathForSelectedRow?.row)!
            let vc = segue.destination as! booknow_confirmation
            if self.filter_customer.count == 0 {
                vc.customer = self.total_customer[index]
            } else {
                vc.customer = self.filter_customer[index]
            }
            vc.checkin_date = self.checkin_date
            vc.checkout_date = self.checkout_date
            vc.company_id = self.company_id
            vc.homestay_id = self.homestay_id
            vc.homestay = self.homestay
            vc.price = self.price
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "to_comfirm", sender: self)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filter_customer = total_customer.filter({( user : Customer) -> Bool in
            return user.get_fullname().lowercased().contains(searchText.lowercased())
        })
        
        user_table.reloadData()
    }
    
    // MARK : Table Protocol
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isFiltering(){
            return filter_customer.count
        }
        return total_customer.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customer_cell", for: indexPath) as! Customer_cell
        var name = String()
        if isFiltering(){
            name = filter_customer[indexPath.row].get_fullname()
        } else {
            name = total_customer[indexPath.row].get_fullname()
        }
        
        cell.name.text = name
        return cell
    }
    
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        self.user_table.separatorStyle = .none

        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.user_table.frame.width / 2) - (width / 2)
        let y = (self.user_table.frame.height / 2) - (height / 2)
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
        
        self.user_table.separatorStyle = .singleLine

        
    }
    
    func dequeueHomestay() {
        
        let ref_Homestay = Database.database().reference().child("Customer").child(self.curruser.get_CID());
        ref_Homestay.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                self.total_customer.removeAll()
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                       let customer = Customer(snapshot: snap )
                       self.total_customer.append(customer!)
                    }
            }
            self.user_table.reloadData()
            })
    }
    
    // start_queue : void -> void
    func start_queue(){
        let ref = Database.database().reference(withPath: "System_User")
        let uid : String = (Auth.auth().currentUser?.uid)!
        
        ref.child(uid).observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.curruser = Employee.init(snapshot: snapshot)!
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
