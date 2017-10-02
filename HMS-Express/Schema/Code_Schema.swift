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
        
        guard let CID = dict["CID"] else { return nil }
        guard let Company_Permit  = dict["Company_Permit"]  else { return nil }
        guard let Company_Name = dict["Company_Name"] else { return nil }
        guard let Code_Number = dict["Code_Number"] else { return nil }
        guard let isUsed = dict["isUsed"] else { return nil }
        
        self.CID = CID as! String
        self.Company_Permit = Company_Permit as! String
        self.Company_Name = Company_Name as! String
        self.Code_Number = Code_Number as! String
        self.isUsed = isUsed as! Bool
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
    
}

