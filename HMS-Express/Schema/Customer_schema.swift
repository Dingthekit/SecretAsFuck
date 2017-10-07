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
    var full_name: String
    var phonenumber: String
    
    // Ctor
    init(first_name: String, last_name: String, full_name: String, phonenumber: String, email: String ) {
        self.first_name = first_name
        self.last_name = last_name
        self.phonenumber = phonenumber
        self.full_name = full_name
        self.email = email

    }
    
    // Dtor
    convenience override init() {
        self.init( first_name: "", last_name: "",full_name : "", phonenumber:  "", email: "")
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        
        guard let first_name = dict["First_name"] else { return nil }
        guard let last_name = dict["Last_name"] else { return nil }
        guard let full_name  = dict["Full_name"]  else { return nil }
        guard let phonenumber = dict["Phone_number"] else { return nil }
        guard let email  = dict["Email"]  else { return nil }

        self.first_name = first_name
        self.last_name = last_name
        self.full_name = full_name
        self.phonenumber = phonenumber
        self.email = email
        
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Customer( first_name: first_name, last_name: last_name ,full_name : full_name, phonenumber:phonenumber, email: email)
        return copy
    }
    
    public func convert_to_list() -> [String : String] {
        return ["First_name" : self.first_name ,
                "Last_name" : self.last_name ,
                "Full_name" : self.full_name ,
                "Phone_number" : self.phonenumber,
                "Email" : self.email ]
    }
    
    public func get_fullname() -> String{
        return self.full_name
    }
    
    
}

