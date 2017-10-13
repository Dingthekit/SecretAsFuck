//
//  Booknow_search_info.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 07/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit

class Booknow_search_info: UIViewController {

    var homestay_Id = String()
     var homestay = Homestay_schema1()
    
    @IBOutlet weak var Homestay_Name: UILabel!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Homestay_Name.text = homestay.get_name()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
