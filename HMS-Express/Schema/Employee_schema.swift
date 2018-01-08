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
        
        guard let dict = snapshot.value as? [ String: String ] else { return nil }
        
        if dict["UID"] != nil  {  self.UID = dict["UID"]! }
        else { self.UID = "" }
        if dict["Email"] != nil  {  self.email = dict["Email"]! }
        else { self.email = "" }
        if dict["First_Name"] != nil  {  self.first_name = dict["First_Name"]! }
        else { self.first_name = "" }
        if dict["Last_Name"] != nil  {  self.last_name = dict["Last_Name"]! }
        else { self.last_name = "" }
        if dict["Phone_Number"] != nil  {  self.phonenumber = dict["Phone_Number"]! }
        else { self.phonenumber = "" }
        if dict["CID"] != nil  {  self.CID = dict["CID"]! }
        else { self.CID = "" }
        if dict["Company_Name"] != nil  {  self.Company_name = dict["Company_Name"]! }
        else { self.Company_name = "" }
        if dict["Privilage"] != nil  {  self.privilage = dict["Privilage"]! }
        else { self.privilage = "" }


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
    
    func set_UID(UID : String) {
        self.UID = UID
    }
    
    func set_email( _ email : String){
        self.email = email
    }
    
    func set_firstname( _ first_name : String ){
        self.first_name = first_name
    }
    
    func set_lastname( _ last_name : String) {
        self.last_name = last_name
    }
    
    func set_phone( _ phonenumber : String ) {
        self.phonenumber = phonenumber
    }
    
    func set_CID( _ CID : String ) {
        self.CID = CID
    }
    
    func set_Compname( _ Company_name : String ) {
        self.Company_name = Company_name
    }
    
    func set_privi( _ privilage : String ) {
        self.privilage = privilage
    }
}
