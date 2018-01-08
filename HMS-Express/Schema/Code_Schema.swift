//
//  Code_Schema.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 30/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//
//

import UIKit
import Firebase

internal class Code: NSObject {
    
    
    private var Code_Number: String
    private var isUsed: Bool
    private var CID: String
    private var Company_Permit: String
    private var Company_Name: String

    
    // Default initialization with variable
    init( _ CID: String , _ Company_Permit: String, _ Company_Name: String, _ Code_Number: String, _ isUsed : Bool ) {
        
        self.CID = CID
        self.Company_Permit = Company_Permit
        self.Company_Name = Company_Name
        self.Code_Number = Code_Number
        self.isUsed = isUsed

        
    }
    
    // Default initialization
    convenience override init() {
        self.init( "", "", "", "", false )
    }
    
    // Ctor : DataSnapshot
    init?(snapshot: DataSnapshot) {
        
        guard let dict = snapshot.value as? [String : AnyObject ] else { return nil }
        
        if dict["CID"] != nil  {  self.CID = dict["CID"]! as! String }
        else { self.CID = "" }
        
        if dict["Company_Permit"] != nil  {  self.Company_Permit = dict["Company_Permit"]! as! String }
        else { self.Company_Permit = "" }
        
        if dict["Company_Name"] != nil  {  self.Company_Name = dict["Company_Name"]! as! String }
        else { self.Company_Name = "" }
        
        if dict["Code_Number"] != nil  {  self.Code_Number = dict["Code_Number"]! as! String }
        else { self.Code_Number = "" }
        
        if dict["isUsed"] != nil  {  self.isUsed = dict["isUsed"]! as! Bool }
        else { self.isUsed = true }

    }
    
    public func convert_to_list() -> [String : Any] {
        return [ "CID": self.CID    ,
                 "Company_Permit": self.Company_Permit ,
                 "Company_Name": self.Company_Name,
                 "Code_Number": self.Code_Number ,
                 "isUsed": self.isUsed ]
    }
    
    // Getters 
    func get_CID() -> String {
        return self.CID
    }
    
    func get_CompPermit() -> String {
        return self.Company_Permit
    }
    
    func get_CompName() -> String {
        return self.Company_Name
    }
    
    func get_Code() -> String {
        return self.Code_Number
    }
    
    func get_validation() -> Bool {
        return !(self.isUsed)
    }
    
    // Getters
    func set_CID(CID : String ) {
        self.CID = CID
    }
    
    func set_CompPermit(Company_Permit : String ) {
        self.Company_Permit = Company_Permit
    }
    
    func set_CompName(Company_Name : String) {
        self.Company_Name = Company_Name
    }
    
    func set_Code(Code_Number : String) {
        self.Code_Number = Code_Number
    }
    
    func set_validation(isUsed : Bool){
         self.isUsed = isUsed
    }
    
}

