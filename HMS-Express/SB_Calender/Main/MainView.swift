//
//  Price_homestay.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 14/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//
import Foundation
import UIKit
import FSCalendar
import Firebase

class Price_homestay: UIViewController {

    // File
    fileprivate let gregorian = Calendar(identifier: .gregorian)

    var company_id = String()
    var homestay_id = String()
    var homestay_name = String()

    // IBOutlet
    @IBOutlet var Calender_segmented: UISegmentedControl!
    
    @IBOutlet var price_view: UIView!
    @IBOutlet var info_view: UIView!
    @IBOutlet var schedule_view: UIView!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "price_segue" {
            let vc = segue.destination as! Price_Controller
            vc.company_id = self.company_id
            vc.homestay_id = self.homestay_id
            //vc.hom
            print("SEGUE!")
            print(vc.company_id)
        }
    }
    
    @IBAction func toggle_type(_ sender: UISegmentedControl) {
        
        sender.changeUnderlinePosition()
        if self.Calender_segmented.selectedSegmentIndex == 0 {
            self.info_view.isHidden = false
            self.price_view.isHidden = true
            self.schedule_view.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.info_view.alpha = 1
                self.price_view.alpha = 0
                self.schedule_view.alpha = 0
            })
        } else if self.Calender_segmented.selectedSegmentIndex == 1 {
            self.info_view.isHidden = true
            self.price_view.isHidden = true
            self.schedule_view.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.info_view.alpha = 0
                self.price_view.alpha = 0
                self.schedule_view.alpha = 1
            })
        }  else  {
            self.info_view.isHidden = true
            self.price_view.isHidden = false
            self.schedule_view.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.info_view.alpha = 0
                self.price_view.alpha = 1
                self.schedule_view.alpha = 0
            })
        }
        
    }
    
    // IBAction
    @IBAction func Back_controller(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard( name : "MainController", bundle : nil )
        let vc = sb.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 2
        self.present(vc, animated: true, completion: nil)
    }
    /*
    // IBAction
    @IBAction func isEdit(_ sender: ToggleButton) {
        self.Price_calender.allowsSelection = !sender.isOn
        self.Price_calender.allowsMultipleSelection = !sender.isOn

        // End Editing
        if sender.isOn {

            // BC : AlertBox return Nothing
            if self.Price_calender.selectedDates.isEmpty {
                sender.NameOfButton =  "Edit"
            } else {
                
                sender.NameOfButton =  "Edit"
                
                // AlertController
                let alertController = UIAlertController(title: "", message: "Price for selected date", preferredStyle: .alert)
                
                // Add TextField
                alertController.addTextField {
                    $0.placeholder = "Price"
                    $0.addTarget(alertController, action: #selector(alertController.textDidChangeInLoginAlert), for: .editingChanged)
                }

                // confirmAction
                let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
                    
                    guard let price_input = alertController.textFields![0].text else { return }
                    
                    for date in self.Price_calender.selectedDates{
                        self.Price_calender.deselect(date)
                        self.listofprice[self.formatter.string(from: date)] = price_input
                    }
                    
                    sender.NameOfButton = "Edit"
                    
                    let ref = Database.database().reference().child("Homestay").child(self.company_id).child(self.homestay_id)
                    ref.child("Price").setValue(self.listofprice)
                    
                    self.Price_calender.reloadData()


                })
                
                // Cancel Action
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                 
                    sender.NameOfButton = "Edit"
                    for date in self.Price_calender.selectedDates{
                        self.Price_calender.deselect(date)
                    }
                    self.Price_calender.reloadData()
                })
                
                confirmAction.isEnabled = false
                alertController.addAction(cancelAction)
                alertController.addAction(confirmAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
            
        // Start Editing
        else { sender.NameOfButton = "Done" }
        
        self.Price_calender.reloadData()
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.homestay_name

        // Hide All Subviews
        self.navigationController?.navigationBar.barStyle = .blackTranslucent

        self.Calender_segmented.addUnderlineForSelectedSegment()
        
        self.info_view.isHidden = false
        self.price_view.isHidden = true
        self.schedule_view.isHidden = true
        
        /*
        // Calender Delegate
        Price_calender.delegate = self
        Price_calender.dataSource = self
        self.Price_calender.register(PriceCalendarCell.self, forCellReuseIdentifier: "price_cell")
        calender_setup()
        label_setup(isOn: true)

        edit_button.initButton("Edit")
        edit_button.activateButton(bool: false)
        
        self.load_price()
        self.load_booking()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.Price_calender.reloadData()
            self.Price_calender.configureAppearance()
        }
*/
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    

    /*
    func load_price() {
        //observing the data changes
        
        let ref_Homestay = Database.database().reference().child("Homestay").child(self.company_id).child(self.homestay_id).child("Price")
        
        ref_Homestay.observeSingleEvent(of: DataEventType.value , with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                // Clearing the list
                self.listofprice.removeAll()
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    let date = snap.key
                    let price = snap.value as! String
                    self.listofprice[date] = price
                }
            }
        })
    }
    */

}
