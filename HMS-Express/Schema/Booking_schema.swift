//
//  booking_Schema.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 20/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//


import UIKit
import Firebase

public class Booking: NSObject {
    
    private var company_id : String
    private var homestay_id: String
    private var homestay_name: String
    private var booking_id: String
    private var user_id: String
    private var user_name: String
    private var checkin_date: String
    private var checkout_date: String
    private var total_price: String
    private var deposit: String
    private var payment : String
    private var note : String
    private var register_by : String
    
    
    // Ctor 
    init(company_id: String, homestay_id: String, homestay_name: String , booking_id: String, user_id : String , user_name : String, checkin_date: String, checkout_date: String , total_price : String, deposit : String , payment : String, note : String, register_by : String) {
        self.company_id = company_id
        self.homestay_id = homestay_id
        self.homestay_name = homestay_name
        self.booking_id = booking_id
        self.user_id = user_id
        self.user_name = user_name
        self.checkin_date = checkin_date
        self.checkout_date = checkout_date
        self.total_price = total_price
        self.deposit = deposit
        self.payment = payment
        self.note = note
        self.register_by = register_by


    }
    
    // Dtor
    convenience override init() {
        self.init(company_id: "", homestay_id: "", homestay_name: "" , booking_id: "", user_id : "", user_name : "", checkin_date:  "", checkout_date:  "", total_price : "0", deposit : "0" , payment : "0", note : "", register_by:   "")
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        
        guard let company_id  = dict["Company_id"]  else { return nil }
        guard let homestay_id = dict["Homestay_id"] else { return nil }
        guard let homestay_name = dict["Homestay_name"] else { return nil }
        guard let booking_id = dict["Booking_id"] else { return nil }
        guard let user_id = dict["User_id"] else { return nil }
        guard let user_name = dict["User_name"] else { return nil }
        guard let checkin_date = dict["Checkin_date"] else { return nil }
        guard let checkout_date = dict["Checkout_date"] else { return nil }
        guard let total_price = dict["Total_price"] else { return nil }
        guard let deposit = dict["Deposit"] else { return nil }
        guard let payment = dict["Payment"] else { return nil }
        guard let note = dict["Note"] else { return nil }
        guard let register_by = dict["Registered_by"] else { return nil }

        
        self.company_id = company_id
        self.homestay_id = homestay_id
        self.homestay_name = homestay_name
        self.booking_id = booking_id
        self.user_id = user_id
        self.user_name = user_name
        self.checkin_date = checkin_date
        self.checkout_date = checkout_date
        self.total_price = total_price
        self.deposit = deposit
        self.payment = payment
        self.note = note
        self.register_by = register_by



    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Booking(company_id: company_id, homestay_id: homestay_id, homestay_name : homestay_name, booking_id: booking_id, user_id : user_id, user_name : user_name, checkin_date:  checkin_date, checkout_date:  checkout_date , total_price : total_price , deposit : deposit , payment : payment, note : note, register_by : register_by)
        return copy
    }
    
    public func convert_to_list() -> [String : String] {
        return ["Company_id" : self.company_id ,
                "Homestay_id" : self.homestay_id ,
                "Homestay_name" : self.homestay_name ,
                "Booking_id" : self.booking_id ,
                "User_id" : self.user_id,
                "User_name" : self.user_name,
                "Checkin_date" : self.checkin_date,
                "Checkout_date" : self.checkout_date,
                "Total_price" : self.total_price ,
                "Deposit" : self.deposit,
                "Payment" : self.payment,
                "Note" : self.note,
                "Registered_by" : self.register_by ]
    }
    
    
    // Setter
    func set_cid(_ key: String) {
        self.company_id = key
    }
    
    func set_hid(_ key: String) {
        self.homestay_id = key
    }
    
    func set_hname(_ key: String) {
        self.homestay_name = key
    }
    
    func set_bid(_ key: String) {
        self.booking_id = key
    }
    
    func set_uid(_ key: String) {
        self.user_id = key
    }
    
    func set_uname(_ key: String) {
        self.user_name = key
    }
    
    func set_checkindate(_ key: String) {
        self.checkin_date = key
    }
    
    func set_checkoutdate(_ key: String) {
        self.checkout_date = key
    }
    
    func set_totalprice(_ key: String) {
        self.total_price = key
    }
    
    func set_deposit(_ key: String) {
        self.deposit = key
    }
    
    func set_payment(_ key: String) {
        self.payment = key
    }
    
    func set_note(_ key: String) {
        self.note = key
    }
    
    func set_registered(_ key: String) {
        self.register_by = key
    }
    
    // Getters
    func get_cid() -> String {
        return self.company_id
    }
    
    func get_hid() -> String {
        return self.homestay_id
    }
    
    func get_hname() -> String {
        return self.homestay_name
    }
    
    func get_bid() -> String {
        return self.booking_id
    }
    
    func get_uid() -> String {
        return self.user_id
    }
    
    func get_uname() -> String {
        return self.user_name
    }
    
    func get_checkindate() -> String {
        return self.checkin_date
    }
    
    func get_checkoutdate() -> String {
        return self.checkout_date
    }
    
    func get_totalprice() -> String {
        return self.total_price
    }
    
    func get_deposit() -> String {
        return self.deposit
    }
    
    func get_payment() -> String {
        return self.payment
    }

    func get_note() -> String {
        return self.note
    }
    
    func get_registered() -> String {
        return self.register_by
    }
    
}

