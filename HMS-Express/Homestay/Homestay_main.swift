//
//  Homestay_main.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 22/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//
 
import UIKit

class Homestay_main: UIViewController {

    
    @IBAction func register_button(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homestay_info_page1") as! Homestay_info_page1
        vc.homestay_info_1 = Homestay_page1.init()
        vc.homestay_info_2 = Homestay_page2.init()
        vc.homestay_info_3 = Homestay_page3.init()

        
        self.present(vc, animated: true, completion: nil)
    }
    
    
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
