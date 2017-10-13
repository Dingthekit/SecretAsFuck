//
//  Homestay_info_page3.swift
//  
//
//  Created by Ding Zhan Chia on 22/09/2017.
//

import UIKit
import Firebase

class Homestay_info_page3: UIViewController {
 
    
    // Variable
    var homestay_info_1 = Homestay_schema1() ;
    var homestay_info_2 = Homestay_schema2() ;
    var homestay_info_3 = Homestay_schema3() ;
    private let ref = Database.database().reference(withPath: "System_User")
    private var curruser = Employee()
    
    // IBOutlet
    @IBOutlet var TV: ToggleButton!
    @IBOutlet var WirelessInternet: ToggleButton!
    @IBOutlet var Shampoo: ToggleButton!
    @IBOutlet var AirCond: ToggleButton!
    @IBOutlet var HairDryer: ToggleButton!
    @IBOutlet var Iron: ToggleButton!
    @IBOutlet var Fridge: ToggleButton!
    @IBOutlet var Microwave: ToggleButton!
    @IBOutlet var Oven: ToggleButton!
    @IBOutlet var WashingMachine: ToggleButton!
    @IBOutlet var Dryer: ToggleButton!
    
    // Prepare Segue
    // 1. Back_2
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "back_2" {
            
            let vc = segue.destination as!  Homestay_info_page2
            
            self.homestay_info_3.set_tv(self.TV.isOn)
            self.homestay_info_3.set_wifi(self.WirelessInternet.isOn)
            self.homestay_info_3.set_shampoo(self.Shampoo.isOn)
            self.homestay_info_3.set_aircond(self.AirCond.isOn)
            self.homestay_info_3.set_hairdryer(self.HairDryer.isOn)
            self.homestay_info_3.set_iron(self.Iron.isOn)
            self.homestay_info_3.set_fridge(self.Fridge.isOn)
            self.homestay_info_3.set_microwave(self.Microwave.isOn)
            self.homestay_info_3.set_oven(self.Oven.isOn)
            self.homestay_info_3.set_washing(self.WashingMachine.isOn)
            self.homestay_info_3.set_dryer(self.Dryer.isOn)

            vc.homestay_info_1 = homestay_info_1.copy() as! Homestay_schema1
            vc.homestay_info_2 = homestay_info_2.copy() as! Homestay_schema2
            vc.homestay_info_3 = homestay_info_3.copy() as! Homestay_schema3
            
        }
    }
    
    // IBAction
    // Confirm_Button
    // Version 1.0
    @IBAction func confirm_button(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "", message: "Everything is entered correctly?", preferredStyle: .alert)
        
        // Confirmation Action. Date: 30 Sept 2017
        let confirmAction = UIAlertAction(title: "Confirm!", style: .default , handler: { (action)-> Void in
            
            self.homestay_info_3.set_tv(self.TV.isOn)
            self.homestay_info_3.set_wifi(self.WirelessInternet.isOn)
            self.homestay_info_3.set_shampoo(self.Shampoo.isOn)
            self.homestay_info_3.set_aircond(self.AirCond.isOn)
            self.homestay_info_3.set_hairdryer(self.HairDryer.isOn)
            self.homestay_info_3.set_iron(self.Iron.isOn)
            self.homestay_info_3.set_fridge(self.Fridge.isOn)
            self.homestay_info_3.set_microwave(self.Microwave.isOn)
            self.homestay_info_3.set_oven(self.Oven.isOn)
            self.homestay_info_3.set_washing(self.WashingMachine.isOn)
            self.homestay_info_3.set_dryer(self.Dryer.isOn)
            
            let CID : String = self.curruser.get_CID()
            
            let key = Database.database().reference().child("Homestay").child(CID).childByAutoId().key
            let homestay_ref = Database.database().reference().child("Homestay").child(CID).child(key)
            
            self.homestay_info_1.set_cid(key)
            self.homestay_info_2.set_cid(key)
            self.homestay_info_3.set_cid(key)

            homestay_ref.child("Name").setValue(self.homestay_info_1.get_name())
            homestay_ref.child("HID").setValue(key)
            homestay_ref.child("HMI_1").setValue(self.homestay_info_1.convert_to_list())
            homestay_ref.child("HMI_2").setValue(self.homestay_info_2.convert_to_list())
            homestay_ref.child("HMI_3").setValue(self.homestay_info_3.convert_to_list())



            let sb = UIStoryboard( name : "MainController", bundle : nil )
            let vc = sb.instantiateViewController(withIdentifier: "Home") as! UITabBarController
            vc.selectedIndex = 1
            self.present(vc, animated: true, completion: nil)
            
        })
        
        // Cancelation Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add 2 Actions
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prerun
        start_queue()
        button_init()
        
    }
    
    // Button Initialization
    func button_init(){
        
        // 1. TV
        TV.initButton("TV")
        TV.activateButton(bool: homestay_info_3.get_tv())
        
        // 2. WIFI
        WirelessInternet.initButton("Wireless Internet")
        WirelessInternet.activateButton(bool: homestay_info_3.get_wifi())
        
        // 3. Shampoo
        Shampoo.initButton("Shampoo")
        Shampoo.activateButton(bool: homestay_info_3.get_shampoo())
        
        // 4. AirCond
        AirCond.initButton("Air Conditioning")
        AirCond.activateButton(bool: homestay_info_3.get_aircond())
        
        // 5. Hair Dryer
        HairDryer.initButton("Hair Dryer")
        HairDryer.activateButton(bool: homestay_info_3.get_hairdryer())
        
        // 6. Iron
        Iron.initButton("Iron")
        Iron.activateButton(bool: homestay_info_3.get_iron())
        
        // 7. Fridge
        Fridge.initButton("Fridge")
        Fridge.activateButton(bool: homestay_info_3.get_fridge())
        
        // 8. Microwave
        Microwave.initButton("Microwave")
        Microwave.activateButton(bool: homestay_info_3.get_microwave())
        
        // 9. Oven
        Oven.initButton("Oven")
        Oven.activateButton(bool: homestay_info_3.get_oven())
        
        // 10. Washing Machinece
        WashingMachine.initButton("Washing Machine")
        WashingMachine.activateButton(bool: homestay_info_3.get_washing())
        
        // 11. Dryer
        Dryer.initButton("Dryer")
        Dryer.activateButton(bool: homestay_info_3.get_dryer())
    }
    
    // start_queue for user information
    func start_queue(){
        
        let uid : String = (Auth.auth().currentUser?.uid)!
        
        self.ref.child(uid).observe(.value, with: { snapshot in
            if snapshot.exists(){
                self.curruser = Employee.init(snapshot: snapshot)!
                print(self.curruser.get_CID())
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    

    
    func defaultvalue(){
        
        if !(homestay_info_3.get_tv()) {
            TV.isOn = homestay_info_3.get_tv()
        }
        
        if !(homestay_info_3.get_wifi()) {
            WirelessInternet.isOn = homestay_info_3.get_wifi()
        }
        if !(homestay_info_3.get_shampoo()) {
            Shampoo.isOn = homestay_info_3.get_shampoo()
        }
        if !(homestay_info_3.get_aircond()) {
            AirCond.isOn = homestay_info_3.get_aircond()
        }
        
        if !(homestay_info_3.get_hairdryer()) {
            HairDryer.isOn = homestay_info_3.get_hairdryer()
        }
        if !(homestay_info_3.get_iron()) {
            Iron.isOn = homestay_info_3.get_iron()
        }
        
        if !(homestay_info_3.get_fridge()) {
            Fridge.isOn = homestay_info_3.get_fridge()
        }
        if !(homestay_info_3.get_microwave()) {
            Microwave.isOn = homestay_info_3.get_microwave()
        }

        if !(homestay_info_3.get_oven()) {
            Oven.isOn = homestay_info_3.get_oven()
        }
        
        if !(homestay_info_3.get_washing()) {
            WashingMachine.isOn = homestay_info_3.get_washing()
        }
        if !(homestay_info_3.get_dryer()) {
            Dryer.isOn = homestay_info_3.get_dryer()
        }
    }

}
