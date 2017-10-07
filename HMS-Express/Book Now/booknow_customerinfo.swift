//
//  booknow_customerinfo.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

class booknow_customerinfo: UIViewController, UISearchResultsUpdating ,UITableViewDelegate, UITableViewDataSource {

    // Variable
    fileprivate var total_user = [Customer]()
    fileprivate var filter_user = [Customer]()
    fileprivate var curruser = Employee()


    // IBOutlet
    @IBOutlet var user_table: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        user_table.tableHeaderView = searchController.searchBar
        definesPresentationContext = true

        
        self.start_queue()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.dequeueHomestay()
            print(self.total_user)
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
        searchController.viewWillDisappear(true)
    }
    
    // MARK : UISearch Protocol
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filter_user = total_user.filter({( user : Customer) -> Bool in
            return user.full_name.lowercased().contains(searchText.lowercased())
        })
        
        user_table.reloadData()
    }
    
    // MARK : Table Protocol
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isFiltering(){
            return filter_user.count
        }
        return total_user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customer_cell", for: indexPath) as! Customer_cell
        
        var name = String()
        
        if isFiltering(){
            name = filter_user[indexPath.row].get_fullname()
        } else {
            name = total_user[indexPath.row].get_fullname()
        }
        
        cell.name.text = name
        return cell
    }
    
    func dequeueHomestay() {
        
        let ref_Homestay = Database.database().reference().child("Customer").child(self.curruser.get_CID());
        ref_Homestay.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                self.total_user.removeAll()
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                       let user = Customer(snapshot: snap )
                       self.total_user.append(user!)
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
