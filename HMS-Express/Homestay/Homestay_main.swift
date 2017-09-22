//
//  Homestay_main.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 22/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//
 
import UIKit

class Homestay_main: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
