//
//  user_schema.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 20/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

internal class Employee: NSObject {
    var email: String
    var first_name: String
    var last_name: String
    var phonenumber: String
    var UID: String
    var privilage: String


    // Default initialization with variable
    init(email: String, first_name: String, last_name: String, phonenumber: String, UID: String , privilage: String) {
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.phonenumber = phonenumber
        self.UID = UID
        self.privilage = privilage

    }
    
    // Default initialization
    convenience override init() {
        self.init(email: "", first_name: "", last_name: "", phonenumber:  "", UID: "", privilage : "")
    }
    
    // Ctor : DataSnapshot
    init?(snapshot: DataSnapshot) {
        
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        
        guard let email  = dict["email"]  else { return nil }
        guard let first_name = dict["first_name"] else { return nil }
        guard let last_name = dict["last_name"] else { return nil }
        guard let phonenumber = dict["phone_number"] else { return nil }
        guard let UID = dict["UID"] else { return nil }
        guard let privilage = dict["privilage"] else { return nil }
 
        self.email = email as! String
        self.first_name = first_name as! String
        self.last_name = last_name as! String
        self.phonenumber = phonenumber as! String
        self.UID = UID as! String
        self.privilage = privilage as! String

    }

}
