//
//  Homestay_page2_schema.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 24/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

internal class Homestay_schema2 : NSObject , NSCopying {
    
    // Variable
    private var HID : String
    private var guest: String
    private var bedroom: String
    private var bathroom: String
    private var kingbed: String
    private var queenbed: String
    private var singlebed: String
    
    // Ctor
    init(HID: String, guest: String, bedroom: String, bathroom: String, kingbed: String, queenbed: String, singlebed: String) {
        
        self.HID = HID
        self.guest = guest
        self.bedroom = bedroom
        self.bathroom = bathroom
        self.kingbed = kingbed
        self.queenbed = queenbed
        self.singlebed = singlebed
    }
    
    // Dtor
    convenience override init() {
        self.init(HID : "" ,guest: "", bedroom: "", bathroom: "", kingbed:  "",  queenbed : "" , singlebed : "")
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        
        if dict["HID"] != nil  {  self.HID = dict["HID"]! }
        else { self.HID = "" }
        
        if dict["guest"] != nil  {  self.guest = dict["guest"]! }
        else { self.guest = "" }
        
        if dict["bedroom"] != nil  {  self.bedroom = dict["bedroom"]! }
        else { self.bedroom = "" }
        
        if dict["bathroom"] != nil  {  self.bathroom = dict["bathroom"]! }
        else { self.bathroom = "" }
        
        if dict["kingbed"] != nil  {  self.kingbed = dict["kingbed"]! }
        else { self.kingbed = "" }
        
        if dict["queenbed"] != nil  {  self.queenbed = dict["queenbed"]! }
        else { self.queenbed = "" }
        
        if dict["singlebed"] != nil  {  self.singlebed = dict["singlebed"]! }
        else { self.singlebed = "" }
        

        
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Homestay_schema2(HID: HID,guest: guest, bedroom: bedroom, bathroom: bathroom , kingbed : kingbed, queenbed : queenbed, singlebed : singlebed)
        return copy
    }
    
    public func convert_to_list() -> [String : String] {
        return [ "HID" : self.HID,
                 "Guest" : self.guest ,
                 "Bedroom" : self.bedroom ,
                 "Bathroom" : self.bathroom ,
                 "KingBed" : self.kingbed ,
                 "QueenBed" : self.queenbed ,
                 "SingleBed" : self.singlebed ]
    }
    
    
    
    // Setter
    func set_hid(_ key: String) {
        self.HID = key
    }
    
    func set_guest(_ key: String) {
        self.guest = key
    }
    
    func set_bedroom(_ key: String) {
        self.bedroom = key
    }
    
    func set_bathroom(_ key: String) {
        self.bathroom = key
    }
    
    func set_kingbed(_ key: String) {
        self.kingbed = key
    }
    
    func set_queenbed(_ key: String) {
        self.queenbed = key
    }
    
    func set_singlebed(_ key: String) {
        self.singlebed = key
    }
    
    
    // Getters
    func get_hid() -> String {
        return self.HID
    }
    
    func get_guest() -> String {
        return self.guest
    }
    
    func get_bedroom() -> String {
        return self.bedroom
    }
    
    func get_bathroom() -> String {
        return self.bathroom
    }
    
    func get_kingbed() -> String {
        return self.kingbed
    }
    
    func get_queenbed()  -> String {
        return self.queenbed
    }
    
    func get_singlebed() -> String {
        return self.singlebed
    }
    
    
}


