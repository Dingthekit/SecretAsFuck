//
//  customer_schema.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 20/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//


import UIKit
import Firebase

public class Customer: NSObject {
    
    var email: String
    var first_name: String
    var last_name: String
    var phonenumber: String
    
    // Ctor
    init(email: String, first_name: String, last_name: String, phonenumber: String) {
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.phonenumber = phonenumber
    }
    
    // Dtor
    convenience override init() {
        self.init(email: "", first_name: "", last_name: "", phonenumber:  "")
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        
        guard let email  = dict["email"]  else { return nil }
        guard let first_name = dict["first_name"] else { return nil }
        guard let last_name = dict["last_name"] else { return nil }
        guard let phonenumber = dict["phonenumber"] else { return nil }
        
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.phonenumber = phonenumber
    }
    
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Customer(email: email, first_name: first_name, last_name: last_name , phonenumber:phonenumber)
        return copy
    }
    
    public func convert_to_list() -> [String : String] {
        return ["email" : self.email ,
                "first_name" : self.first_name ,
                "last_name" : self.last_name ,
                "phonenumber" : self.phonenumber ]
    }
}

