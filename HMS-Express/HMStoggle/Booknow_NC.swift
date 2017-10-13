//
//  Booknow_NC.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 10/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit

class Booknow_NC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.init(red: 44/255, green: 74/255, blue: 97/255, alpha: 1)
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]

        self.navigationBar.tintColor = UIColor.white
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
