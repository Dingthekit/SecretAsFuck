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
    var tv: Bool
    var wifi: Bool
    var shampoo: Bool
    var aircond: Bool
    var hairdryer: Bool
    var iron: Bool
    var fridge: Bool
    var microwave: Bool
    var oven: Bool
    var washing: Bool
    var dryer: Bool
    
    // Ctor
    init(tv: Bool, wifi: Bool, shampoo: Bool, aircond: Bool, hairdryer: Bool, iron: Bool , fridge: Bool, microwave: Bool, oven: Bool, washing: Bool, dryer: Bool) {
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
        self.init(tv: false, wifi: false, shampoo: false, aircond:  false,  hairdryer : false , iron : false, fridge: false, microwave: false, oven: false, washing:  false,  dryer : false)
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Bool] else { return nil }
        
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
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Homestay_schema3(tv: tv, wifi: wifi, shampoo: shampoo , aircond : aircond, hairdryer : hairdryer, iron : iron , fridge : fridge , microwave : microwave, oven : oven ,washing : washing, dryer :dryer  )
        return copy
    }
    
    public func convert_to_list() -> [String : Bool]{
        return ["TV" : self.tv ,
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
    
    
}



