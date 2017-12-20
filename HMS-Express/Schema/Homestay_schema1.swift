//
//  homestay_schema.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 20/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//


import UIKit
import Firebase

internal class Homestay_schema1: NSObject, NSCopying{
    
    // page 1
    private var HID  : String
    private var name: String
    private var address1: String
    private var address2: String
    private var postalcode: String
    private var city: String
    private var state: String
    private var typeofhomestay: String

    
    // Ctor
    init(HID : String ,name: String, address1: String, address2: String, postalcode: String, city: String, state: String, typeofhomestay: String) {
        self.HID = HID
        self.name = name
        self.address1 = address1
        self.address2 = address2
        self.postalcode = postalcode
        self.city = city
        self.state = state
        self.typeofhomestay = typeofhomestay

    }
     
    // Dtor
    convenience override init() {
        self.init(HID: "" ,name: "", address1: "", address2: "", postalcode:  "",  city : "" , state : "", typeofhomestay: "")
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        
        guard let HID  = dict["HID"]  else { return nil }
        guard let name  = dict["Name"]  else { return nil }
        guard let address1 = dict["Address1"] else { return nil }
        guard let address2 = dict["Address2"] else { return nil }
        guard let postalcode = dict["PostalCode"] else { return nil }
        guard let city = dict["City"] else { return nil }
        guard let state = dict["State"] else { return nil }
        guard let typeofhomestay = dict["TypeOfHome"] else { return nil }

        self.HID = HID
        self.name = name
        self.address1 = address1
        self.address2 = address2
        self.postalcode = postalcode
        self.city = city
        self.state = state
        self.typeofhomestay = typeofhomestay

    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Homestay_schema1( HID : HID, name: name, address1: address1, address2:  address2, postalcode: postalcode, city: city, state: state , typeofhomestay: typeofhomestay)
        return copy
    }
    
    public func convert_to_list() -> [String : String] {
        return [ "HID" : self.HID,
                 "Name" : self.name ,
                 "Address1" : self.address1 ,
                 "Address2" : self.address2 ,
                 "PostalCode" : self.postalcode ,
                 "City" : self.city ,
                 "State" : self.state,
                 "TypeOfHome" : self.typeofhomestay ]
    }
    
    // Setter
    func set_hid(_ key: String) {
        self.HID = key
    }
    
    func set_name(_ key: String) {
        self.name = key
    }
    
    func set_add1(_ key: String) {
        self.address1 = key
    }
    
    func set_add2(_ key: String) {
        self.address2 = key
    }
    
    func set_pos(_ key: String) {
        self.postalcode = key
    }
    
    func set_state(_ key: String) {
        self.state = key
    }
    
    func set_type(_ key: String) {
        self.typeofhomestay = key
    }
    
    func set_city(_ key: String) {
        self.city = key
    }
    

    // Getters
    func get_hid() -> String {
        return self.HID
    }
    
    func get_name() -> String {
        return self.name
    }
    
    func get_add1() -> String {
        return self.address1
    }
    
    func get_add2() -> String {
        return self.address2
    }
    
    func get_pos() -> String {
        return self.postalcode
    }
    
    func get_state()  -> String {
        return self.state
    }
    
    func get_type() -> String {
        return self.typeofhomestay
    }
    
    func get_city() -> String {
        return self.city
    }
    

}
