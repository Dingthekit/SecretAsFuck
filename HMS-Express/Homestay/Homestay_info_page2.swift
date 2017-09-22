
//
//  Homestay_info_page2.swift
//  
//
//  Created by Ding Zhan Chia on 22/09/2017.
//

import UIKit

class Homestay_info_page2: UIViewController {

    @IBAction func confirm_button(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homestay_info_page1")
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
