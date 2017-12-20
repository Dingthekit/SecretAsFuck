//
//  Login.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 19/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

class Login: UIViewController, UITextFieldDelegate , NVActivityIndicatorViewable{
    
    // Variable
    fileprivate var ref: DatabaseReference!
    fileprivate var isUserFound_bool : Bool = true {
            didSet {
                if isUserFound_bool {
                    // Add Subview while queuing
                    let blurEffect = UIBlurEffect(style: .dark )
                    let blurEffectView = UIVisualEffectView(effect: blurEffect)
                    blurEffectView.frame = self.view.frame
                    self.sampleindicator.startAnimating()
                    self.view.insertSubview(blurEffectView, at: 0)
                    self.view.addSubview(self.sampleindicator)
                    
                } else {
                    self.sampleindicator.stopAnimating()
                    self.view.subviews[0].removeFromSuperview()
                    
                }
            }
    }
    fileprivate var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    fileprivate var sampleindicator : NVActivityIndicatorView = NVActivityIndicatorView(frame:  CGRect(x: UIScreen.main.bounds.size.width * 0.5 - 25 , y: UIScreen.main.bounds.size.height * 0.5 - 25, width: 50, height: 50), type: .ballRotateChase , color: UIColor.black , padding: CGFloat(0))
    
    // OBOutlet
    @IBOutlet var email_uitext: UITextField!
    @IBOutlet var password_uitext: UITextField!
    
    // IBAction
    @IBAction func loginAction(_ sender: AnyObject) {
        self.view.endEditing(true)
       login_function()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Delegate
        email_uitext.delegate = self
        email_uitext.tag = 1
        password_uitext.delegate = self
        password_uitext.tag = 2
        
        // Underline
        email_uitext.useUnderLine()
        password_uitext.useUnderLine()
        // Dismiss Keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    

    
    // Keyboard Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // Function: Login Function -> Void
    private func login_function() {
        
        
        // If Email_Empty
        if ( self.email_uitext.text?.isEmpty )!  {
            
            let alert = UIAlertController(title: "", message: "Please enter your email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
        // If Password_Empty
        else if ( self.password_uitext.text?.isEmpty )! {
            
            let alert = UIAlertController(title: "", message: "Please enter your password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
          
        // If both things are valid
        else {
            Auth.auth().signIn(withEmail: self.email_uitext.text!, password: self.password_uitext.text!) { (user, error) in
                
                self.isUserFound_bool = false
            
                self.first_time( (Auth.auth().currentUser?.uid)! )
                UIApplication.shared.beginIgnoringInteractionEvents()


                self.sampleindicator.stopAnimating()
                self.view.subviews[0].removeFromSuperview()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if error != nil {
                    
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                

            }
        }
    } // END FUNC
    
    func textFieldDidBeginEditing( _ textField: UITextField ) {
            textField.useUnderLine_whileediting()
    }
    
    func textFieldDidEndEditing( _ textField: UITextField) {
        textField.useUnderLine()
    }
    
    private func first_time(_ uid : String ){
        
        let ref = Database.database().reference(withPath: "System_User").child(uid)
        
        ref.observe(.value, with: { snapshot in
            
            // if there exist the snapshot
            if snapshot.exists(){
                let sb = UIStoryboard ( name : "MainController" , bundle : nil)
                let vc = sb.instantiateViewController(withIdentifier: "Home")
                vc.modalTransitionStyle = .flipHorizontal
                self.present(vc, animated: true, completion: nil)
            }
            
            // there is no data
            else {
                let sb = UIStoryboard( name : "Welcome" , bundle : nil)
                let vc = sb.instantiateViewController(withIdentifier: "Welcome_main")
                vc.modalTransitionStyle = .flipHorizontal
                self.present(vc, animated: true, completion: nil)
            }
            })
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        self.setNeedsStatusBarAppearanceUpdate()
        return .default
    }
    
    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension UINavigationController
{
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


