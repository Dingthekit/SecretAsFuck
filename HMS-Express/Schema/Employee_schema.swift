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
    
    private var UID: String
    private var email: String
    private var first_name: String
    private var last_name: String
    private var phonenumber: String
    private var CID: String
    private var Company_name: String
    private var privilage: String


    // Default initialization with variable
    init( _ UID: String , _ email: String, _ first_name: String, _ last_name: String, _ phonenumber: String, _ CID: String , _ Company_name: String, _ privilage: String) {
        
        self.UID = UID
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.phonenumber = phonenumber
        self.CID = CID
        self.Company_name = Company_name
        self.privilage = privilage

    }
    
    // Default initialization
    convenience override init() {
        self.init( "", "", "", "", "", "", "" ,"")
    }
    
    // Ctor : DataSnapshot
    init?(snapshot: DataSnapshot) {
        
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        
        guard let UID = dict["UID"] else { return nil }
        guard let email  = dict["Email"]  else { return nil }
        guard let first_name = dict["First_Name"] else { return nil }
        guard let last_name = dict["Last_Name"] else { return nil }
        guard let phonenumber = dict["Phone_Number"] else { return nil }
        guard let CID = dict["CID"] else { return nil }
        guard let Company_name = dict["Company_Name"] else { return nil }
        guard let privilage = dict["Privilage"] else { return nil }
        
        self.UID = UID as! String
        self.email = email as! String
        self.first_name = first_name as! String
        self.last_name = last_name as! String
        self.phonenumber = phonenumber as! String
        self.CID = CID as! String
        self.Company_name = Company_name as! String
        self.privilage = privilage as! String

    }
    
    public func convert_to_list() -> [String : String] {
        return [ "UID": self.UID,
                 "Email": self.email ,
                 "First_Name": self.first_name,
                 "Last_Name": self.last_name ,
                 "Phone_Number": self.phonenumber,
                 "CID" : self.CID,
                 "Privilage": self.privilage ,
                 "Company_Name" : self.Company_name ]
    }

    // Getters
    func get_UID() -> String {
        return self.UID
    }
    
    func get_email() -> String {
        return self.email
    }
    
    func get_firstname() -> String {
        return self.first_name
    }
    
    func get_lastname() -> String {
        return self.last_name
    }
    
    func get_phone() -> String {
        return self.phonenumber
    }
    
    func get_CID() -> String {
        return self.CID
    }
    
    func get_CompName() -> String {
        return self.Company_name
    }
    
    func get_privi() -> String {
        return self.privilage
    }
    
}
