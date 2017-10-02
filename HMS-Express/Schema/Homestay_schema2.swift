//
//  Homestay_page2_schema.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 24/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Firebase

internal class Homestay_schema2 : NSObject , NSCopying {
    
    // Variable
    var guest: String
    var bedroom: String
    var bathroom: String
    var kingbed: String
    var queenbed: String
    var singlebed: String
    
    // Ctor
    init(guest: String, bedroom: String, bathroom: String, kingbed: String, queenbed: String, singlebed: String) {
        self.guest = guest
        self.bedroom = bedroom
        self.bathroom = bathroom
        self.kingbed = kingbed
        self.queenbed = queenbed
        self.singlebed = singlebed
    }
    
    // Dtor
    convenience override init() {
        self.init(guest: "", bedroom: "", bathroom: "", kingbed:  "",  queenbed : "" , singlebed : "")
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        
        guard let guest  = dict["guest"]  else { return nil }
        guard let bedroom = dict["bedroom"] else { return nil }
        guard let bathroom = dict["bathroom"] else { return nil }
        guard let kingbed = dict["kingbed"] else { return nil }
        guard let queenbed = dict["queenbed"] else { return nil }
        guard let singlebed = dict["singlebed"] else { return nil }
        
        self.guest = guest
        self.bedroom = bedroom
        self.bathroom = bathroom
        self.kingbed = kingbed
        self.queenbed = queenbed
        self.singlebed = singlebed
        
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Homestay_schema2(guest: guest, bedroom: bedroom, bathroom: bathroom , kingbed : kingbed, queenbed : queenbed, singlebed : singlebed)
        return copy
    }
    
    public func convert_to_list() -> [String : String] {
        return [ "Guest" : self.guest ,
                 "Bedroom" : self.bedroom ,
                 "Bathroom" : self.bathroom ,
                 "KingBed" : self.kingbed ,
                 "QueenBed" : self.queenbed ,
                 "SingleBed" : self.singlebed ]
    }
    
}


