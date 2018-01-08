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
    
    private var email: String
    private var first_name: String
    private var last_name: String
    private var full_name: String
    private var phonenumber: String
    private var CID: String
    
    // Ctor
    init(first_name: String, last_name: String, full_name: String, phonenumber: String, email: String , CID : String ) {
        self.first_name = first_name
        self.last_name = last_name
        self.phonenumber = phonenumber
        self.full_name = full_name
        self.email = email
        self.CID = CID

    }
    
    // Dtor
    convenience override init() {
        self.init( first_name: "", last_name: "",full_name : "", phonenumber:  "", email: "" , CID : "")
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        
        
        if dict["First_name"] != nil  {  self.first_name = dict["First_name"]! }
        else { self.first_name = "" }
        
        if dict["Last_name"] != nil  {  self.last_name = dict["Last_name"]! }
        else { self.last_name = "" }
        
        if dict["Full_name"] != nil  {  self.full_name = dict["Full_name"]! }
        else { self.full_name = "" }
        
        if dict["Phone_number"] != nil  {  self.phonenumber = dict["Phone_number"]! }
        else { self.phonenumber = "" }
        
        if dict["Email"] != nil  {  self.email = dict["Email"]! }
        else { self.email = "" }
        
        if dict["CID"] != nil  {  self.CID = dict["CID"]! }
        else { self.CID = "" }

        
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Customer( first_name : first_name, last_name : last_name ,full_name : full_name, phonenumber : phonenumber, email : email, CID : CID)
        return copy
    }
    
    public func convert_to_list() -> [String : String] {
        return ["First_name" : self.first_name ,
                "Last_name" : self.last_name ,
                "Full_name" : self.full_name ,
                "Phone_number" : self.phonenumber,
                "Email" : self.email,
                "CID" : self.CID ]
    }
    
    func set_firstname(_  key : String ){
        self.first_name = key
    }
    
    func set_lastnam( _ key : String ){
        self.last_name = key
    }
    
    func set_fullname( _ key : String ){
        self.full_name = key
    }
    
    func set_email( _ key : String ){
        self.email = key
    }
    
    func set_phonenumber( _ key : String ){
        self.phonenumber = key
    }
    
    func set_CID( _ key : String ){
        self.CID = key
    }
    
    // Getter
    
    func get_firstname() -> String {
        return self.first_name
    }
    
    func get_lastname() -> String{
        return self.last_name
    }
    
    func get_fullname() -> String{
        return self.full_name
    }
    
    func get_email() -> String{
        return self.email
    }
    
    func get_phonenumber() -> String{
        return self.phonenumber
    }
    
    func get_CID() -> String{
        return self.CID
    }
    
    
}

