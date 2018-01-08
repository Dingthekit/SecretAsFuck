//
//  company_schema.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 20/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//


import UIKit
import Firebase

private class Company: NSObject {
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
        
        if dict["email"] != nil  {  self.email = dict["email"]! }
        else { self.email = "" }
        
        if dict["first_name"] != nil  {  self.first_name = dict["first_name"]! }
        else { self.first_name = "" }
        
        if dict["last_name"] != nil  {  self.last_name = dict["last_name"]! }
        else { self.last_name = "" }
        
        if dict["phonenumber"] != nil  {  self.phonenumber = dict["phonenumber"]! }
        else { self.phonenumber = "" }
        
        if dict["company_name"] != nil  {  self.company_name = dict["company_name"]! }
        else { self.company_name = "" }

    }
    
    
}

