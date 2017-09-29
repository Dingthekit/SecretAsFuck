//
//  Homestay_info_page3.swift
//  
//
//  Created by Ding Zhan Chia on 22/09/2017.
//

import UIKit

class Homestay_info_page3: UIViewController {
 
    
    // Variable
    var homestay_info_1 = Homestay_page1() ;
    var homestay_info_2 = Homestay_page2() ;
    var homestay_info_3 = Homestay_page3() ;
    
    // IBAction
    @IBAction func back_button(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homestay_info_page2") as! Homestay_info_page2
        
        homestay_info_3 = Homestay_page3( tv: TV.isOn, wifi: WirelessInternet.isOn,shampoo: Shampoo.isOn,aircond: AirCond.isOn,hairdryer: HairDryer.isOn,iron: Iron.isOn, fridge: Fridge.isOn , microwave: Microwave.isOn ,oven: Oven.isOn , washing: WashingMachine.isOn , dryer: Dryer.isOn)
        vc.homestay_info_1 = homestay_info_1.copy() as! Homestay_page1
        vc.homestay_info_2 = homestay_info_2.copy() as! Homestay_page2
        vc.homestay_info_3 = homestay_info_3.copy() as! Homestay_page3
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func next_button(_ sender: AnyObject) {
 
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button_init()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func button_init(){
        TV.initButton("TV")
        TV.activateButton(bool: homestay_info_3.tv)
        WirelessInternet.initButton("Wireless Internet")
        WirelessInternet.activateButton(bool: homestay_info_3.wifi)
        Shampoo.initButton("Shampoo")
        Shampoo.activateButton(bool: homestay_info_3.shampoo)
        AirCond.initButton("Air Conditioning")
        AirCond.activateButton(bool: homestay_info_3.aircond)
        HairDryer.initButton("Hair Dryer")
        HairDryer.activateButton(bool: homestay_info_3.hairdryer)
        Iron.initButton("Iron")
        Iron.activateButton(bool: homestay_info_3.iron)
        Fridge.initButton("Fridge")
        Fridge.activateButton(bool: homestay_info_3.fridge)
        Microwave.initButton("Microwave")
        Microwave.activateButton(bool: homestay_info_3.microwave)
        Oven.initButton("Oven")
        Oven.activateButton(bool: homestay_info_3.oven)
        WashingMachine.initButton("Washing Machine")
        WashingMachine.activateButton(bool: homestay_info_3.washing)
        Dryer.initButton("Dryer")
        Dryer.activateButton(bool: homestay_info_3.dryer)
    }



}
