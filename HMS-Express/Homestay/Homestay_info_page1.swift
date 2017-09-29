//
//  Homestay_info_page1.swift
//  
//
//  Created by Ding Zhan Chia on 22/09/2017.
//

import UIKit
import Firebase
import FirebaseAuth

class Homestay_info_page1: UIViewController, UITextFieldDelegate {
    
    // Variable
    var homestay_info_1 = Homestay_page1() ;
    var homestay_info_2 = Homestay_page2() ;
    var homestay_info_3 = Homestay_page3() ;
    
    // PageControl
    var pageControl = UIPageControl()
    
    // IBoutlet
    @IBOutlet var Name : UITextField!
    @IBOutlet var Address_1 : UITextField!
    @IBOutlet var Address_2 : UITextField!
    @IBOutlet var Postal_code: UITextField!
    @IBOutlet var City: UITextField!
    @IBOutlet var State: UITextField!
    @IBOutlet var Type_Homestay : UITextField!
    
    // IBAction
    @IBAction func back_button(_ sender: AnyObject) {
        
        // Navigate to the next item
        let sb = UIStoryboard( name : "MainController", bundle : nil )
        let vc = sb.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        vc.selectedIndex = 1
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func next_button(_ sender: AnyObject) {
        
        homestay_info_1 =  Homestay_page1.init( name: Name.text! , address1: Address_1.text! , address2: Address_2.text!, postalcode: Postal_code.text! , city: City.text! , state: State.text! , typeofhomestay: Type_Homestay.text! )
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homestay_info_page2") as! Homestay_info_page2

        vc.homestay_info_1 = homestay_info_1.copy() as! Homestay_page1
        vc.homestay_info_2 = homestay_info_2.copy() as! Homestay_page2
        vc.homestay_info_3 = homestay_info_3.copy() as! Homestay_page3
        
        self.present(vc, animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.Name.delegate = self
        defaultvalue()
        
        // PageControl
        configurePageControl(0)
        
        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // Page Control
    func configurePageControl( _ CurrPage : Int) {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = CurrPage
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }

    func defaultvalue(){
        
        if !(homestay_info_1.name.isEmpty) {
            Name.text = homestay_info_1.name
        }

        if !(homestay_info_1.address1.isEmpty) {
            Address_1.text = homestay_info_1.address1
        }
        if !(homestay_info_1.address2.isEmpty) {
            Address_2.text = homestay_info_1.address2
        }
        if !(homestay_info_1.postalcode.isEmpty) {
            Postal_code.text = homestay_info_1.postalcode
        }
        if !(homestay_info_1.city.isEmpty) {
            City.text = homestay_info_1.city
        }
        if !(homestay_info_1.state.isEmpty) {
            State.text = homestay_info_1.state
        }
        if !(homestay_info_1.typeofhomestay.isEmpty) {
            Type_Homestay.text = homestay_info_1.typeofhomestay
        }
    }
}
