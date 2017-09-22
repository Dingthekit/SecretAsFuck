//
//  customer_schema.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 20/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//


import UIKit
import Firebase

private class Customer: NSObject {
    var email: String
    var first_name: String
    var last_name: String
    var phonenumber: String
    var company_name: String
     
    // Ctor
    init(email: String, first_name: String, last_name: String, phonenumber: String, company_name: String) {
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.phonenumber = phonenumber
        self.company_name = company_name
    }
    
    // Dtor
    convenience override init() {
        self.init(email: "", first_name: "", last_name: "", phonenumber:  "", company_name:  "")
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        
        guard let email  = dict["email"]  else { return nil }
        guard let first_name = dict["first_name"] else { return nil }
        guard let last_name = dict["last_name"] else { return nil }
        guard let phonenumber = dict["phonenumber"] else { return nil }
        guard let company_name = dict["company_name"] else { return nil }
        
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.phonenumber = phonenumber
        self.company_name = company_name
    }
    
    
}

