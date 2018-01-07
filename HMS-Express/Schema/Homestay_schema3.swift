//
//  Homestay_schema3.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 30/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

internal class Homestay_schema3 : NSObject, NSCopying {
    
    // Variable
    private var HID: String
    private var tv: Bool
    private var wifi: Bool
    private var shampoo: Bool
    private var aircond: Bool
    private var hairdryer: Bool
    private var iron: Bool
    private var fridge: Bool
    private var microwave: Bool
    private var oven: Bool
    private var washing: Bool
    private var dryer: Bool
    
    // Ctor
    init(HID: String,tv: Bool, wifi: Bool, shampoo: Bool, aircond: Bool, hairdryer: Bool, iron: Bool , fridge: Bool, microwave: Bool, oven: Bool, washing: Bool, dryer: Bool) {
        self.HID = HID
        self.tv = tv
        self.wifi = wifi
        self.shampoo = shampoo
        self.aircond = aircond
        self.hairdryer = hairdryer
        self.iron = iron
        self.fridge = fridge
        self.microwave = microwave
        self.oven = oven
        self.washing = washing
        self.dryer = dryer
    }
    
    // Dtor
    convenience override init() {
        self.init(HID : "" , tv: false, wifi: false, shampoo: false, aircond:  false,  hairdryer : false , iron : false, fridge: false, microwave: false, oven: false, washing:  false,  dryer : false)
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any] else { return nil }
        
        guard let HID  = dict["HID"]  else { return nil }
        guard let tv  = dict["tv"]  else { return nil }
        guard let wifi = dict["wifi"] else { return nil }
        guard let shampoo = dict["shampoo"] else { return nil }
        guard let aircond = dict["aircond"] else { return nil }
        guard let hairdryer = dict["hairdryer"] else { return nil }
        guard let iron = dict["iron"] else { return nil }
        guard let fridge  = dict["fridge"]  else { return nil }
        guard let microwave = dict["microwave"] else { return nil }
        guard let oven = dict["oven"] else { return nil }
        guard let washing = dict["washing"] else { return nil }
        guard let dryer = dict["dryer"] else { return nil }
        
        self.HID = HID as! String
        self.tv = tv as! Bool 
        self.wifi = wifi as! Bool
        self.shampoo = shampoo as! Bool
        self.aircond = aircond as! Bool
        self.hairdryer = hairdryer as! Bool
        self.iron = iron as! Bool
        self.fridge = fridge as! Bool
        self.microwave = microwave as! Bool
        self.oven = oven as! Bool
        self.washing = washing as! Bool
        self.dryer = dryer as! Bool
        
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Homestay_schema3(HID : HID , tv: tv, wifi: wifi, shampoo: shampoo , aircond : aircond, hairdryer : hairdryer, iron : iron , fridge : fridge , microwave : microwave, oven : oven ,washing : washing, dryer :dryer  )
        return copy
    }
    
    public func convert_to_list() -> [String : Any] {
        return ["HID" : self.HID,
                "TV" : self.tv ,
                "WIFI" : self.wifi ,
                "Shampoo" : self.aircond,
                "Hairdryer" : self.hairdryer ,
                "Iron" : self.iron,
                "Fridge" : self.fridge ,
                "Microwave" : self.microwave,
                "Oven" : self.oven ,
                "Washing" : self.washing,
                "Dryer" : self.dryer ]
    }
    
    // Setter
    func set_hid(_ key: String) {
        self.HID = key
    }
    
    func set_tv(_ key: Bool) {
        self.tv = key
    }
    
    func set_wifi(_ key: Bool) {
        self.wifi = key
    }
    
    func set_shampoo(_ key: Bool) {
        self.shampoo = key
    }
    
    func set_hairdryer(_ key: Bool) {
        self.hairdryer = key
    }
    
    func set_iron(_ key: Bool) {
        self.iron = key
    }
    
    func set_aircond(_ key: Bool) {
        self.aircond = key
    }
    func set_fridge(_ key: Bool) {
        self.fridge = key
    }
    
    func set_microwave(_ key: Bool) {
        self.microwave = key
    }
    
    func set_oven(_ key: Bool) {
        self.oven = key
    }
    
    func set_washing(_ key: Bool) {
        self.washing = key
    }
    
    func set_dryer(_ key: Bool) {
        self.dryer = key
    }
    
    
    // Getters
    func get_hid()  -> String {
        return self.HID
    }
    
    func get_tv()  -> Bool {
        return self.tv
    }
    
    func get_wifi()  -> Bool {
        return self.wifi
    }
    
    func get_shampoo()  -> Bool {
        return self.shampoo
    }
    
    func get_aircond()  -> Bool {
        return self.aircond
    }
    
    func get_hairdryer()  -> Bool {
        return self.hairdryer
    }
    
    func get_iron()  -> Bool {
        return self.iron
    }
    
    func get_fridge()  -> Bool {
        return self.fridge
    }
    
    func get_microwave() -> Bool  {
        return self.microwave
    }
    
    func get_oven() -> Bool {
        return self.oven
    }
    
    func get_washing()  -> Bool {
        return self.washing
    }
    
    func get_dryer() -> Bool {
        return self.dryer
    }
    
    
    
    
}



