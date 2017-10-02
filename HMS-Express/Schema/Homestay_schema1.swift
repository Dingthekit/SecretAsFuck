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
    var name: String
    var address1: String
    var address2: String
    var postalcode: String
    var city: String
    var state: String
    var typeofhomestay: String

    
    // Ctor
    init(name: String, address1: String, address2: String, postalcode: String, city: String, state: String, typeofhomestay: String) {
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
        self.init(name: "", address1: "", address2: "", postalcode:  "",  city : "" , state : "", typeofhomestay: "")
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        
        guard let name  = dict["Name"]  else { return nil }
        guard let address1 = dict["Address1"] else { return nil }
        guard let address2 = dict["Address2"] else { return nil }
        guard let postalcode = dict["PostalCode"] else { return nil }
        guard let city = dict["City"] else { return nil }
        guard let state = dict["State"] else { return nil }
        guard let typeofhomestay = dict["TypeOfHome"] else { return nil }

        self.name = name
        self.address1 = address1
        self.address2 = address2
        self.postalcode = postalcode
        self.city = city
        self.state = state
        self.typeofhomestay = typeofhomestay

    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Homestay_schema1( name: name, address1: address1, address2:  address2, postalcode: postalcode, city: city, state: state , typeofhomestay: typeofhomestay)
        return copy
    }
    
    public func convert_to_list() -> [String : String] {
        return [ "Name" : self.name ,
                 "Address1" : self.address1 ,
                 "Address2" : self.address2 ,
                 "PostalCode" : self.postalcode ,
                 "City" : self.city ,
                 "State" : self.state,
                 "TypeOfHome" : self.typeofhomestay ]
    }
    
    // Getters
    func get_name() -> String {
        return self.name
    }
    
    func get_Location() -> String {
        return self.city
    }
    

}
