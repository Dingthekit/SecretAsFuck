//
//  backupfile.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 05/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import Foundation
/*
 
 //
 //  booknow_main.swift
 //  HMS-Express
 //
 //  Created by Ding Zhan Chia on 19/09/2017.
 //  Copyright © 2017 Ding Zhan Chia. All rights reserved.
 //
 
 import UIKit
 import FSCalendar
 
 class booknow_main: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
 
 
 // Variable
 var checkin_picker = UIDatePicker()
 var checkout_picker = UIDatePicker()
 
 // IBOutlet
 @IBOutlet var checkin_uitext: UITextField!
 @IBOutlet var checkout_uitext: UITextField!
 @IBOutlet var adult_uitext: UITextField!
 @IBOutlet var children_uitext: UITextField!
 
 @IBOutlet var samplesubview: UIView!
 @IBOutlet var Calender: FSCalendar!
 
 @IBAction func to_subview(_ sender: UIButton) {
 let blurEffect = UIBlurEffect(style: .dark )
 let blurEffectView = UIVisualEffectView(effect: blurEffect)
 self.view.insertSubview(blurEffectView, at: 0)
 self.samplesubview.center = CGPoint(x: (self.view.superview?.frame.size.width)! / 2,
 y: (self.view.superview?.frame.size.height)! / 2)
 self.view.addSubview(self.samplesubview)
 self.samplesubview.isHidden = false
 
 }
 
 @IBAction func back_subview(_ sender: UIButton) {
 self.samplesubview.removeFromSuperview()
 self.view.subviews[0].removeFromSuperview()
 }
 
 // IBAction
 @IBAction func AddAction_adult(_ sender: UIButton) {
 if (adult_uitext.text?.isEmpty)! {
 adult_uitext.text = "0";
 } else{
 var adult_pax : Int = Int(adult_uitext.text!)!
 adult_pax += 1
 adult_uitext.text = String(adult_pax)
 }
 }
 
 @IBAction func MinusAction_adult(_ sender: UIButton) {
 if (adult_uitext.text?.isEmpty)! {
 adult_uitext.text = "0";
 } else{
 var adult_pax : Int = Int(adult_uitext.text!)!
 if adult_pax == 0 {
 adult_pax = 0
 } else{
 adult_pax -= 1
 }
 adult_uitext.text = String(adult_pax)
 }
 }
 
 @IBAction func AddAction_child(_ sender: UIButton) {
 if (children_uitext.text?.isEmpty)! {
 children_uitext.text = "0";
 } else{
 var child_pax : Int = Int(children_uitext.text!)!
 child_pax += 1
 children_uitext.text = String(child_pax)
 }
 }
 
 @IBAction func MinusAction_child(_ sender: UIButton) {
 if (children_uitext.text?.isEmpty)! {
 children_uitext.text = "0";
 } else{
 var child_pax : Int = Int(children_uitext.text!)!
 if child_pax == 0 {
 child_pax = 0
 } else{
 child_pax -= 1
 }
 children_uitext.text = String(child_pax)
 }
 }
 
 // ViewDidLoad
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Date Picker
 checkin_picker.datePickerMode = UIDatePickerMode.date
 checkin_picker.date = .init()
 checkin_picker.minimumDate = Date()
 
 checkout_picker.datePickerMode = UIDatePickerMode.date
 checkout_picker.date = .init()
 checkout_picker.minimumDate = Date()
 
 // Toolbar
 let toolBar = UIToolbar()
 toolBar.barStyle = UIBarStyle.default
 toolBar.isTranslucent = true
 toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
 toolBar.sizeToFit()
 
 let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(booknow_main.donePicker))
 let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
 let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(booknow_main.cancelPicker))
 
 toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
 toolBar.isUserInteractionEnabled = true
 
 
 checkin_uitext.inputAccessoryView = toolBar
 checkin_uitext.inputView = checkin_picker
 
 // Date
 checkout_uitext.inputAccessoryView = toolBar
 checkout_uitext.inputView = checkout_picker
 
 Calender_setup()
 
 self.Calendar.dataSource = self;
 self.Calendar.delegate = self;
 
 }
 
 
 // Toolbar
 func donePressed(){
 view.endEditing(true)
 }
 
 func cancelPressed(){
 view.endEditing(true)
 }
 
 // DoneButton
 @objc func donePicker(sender: UIButton){
 if checkin_uitext.isFirstResponder{
 checkin_uitext.endEditing(true)
 
 let dateformatter = DateFormatter()
 dateformatter.dateStyle = .long
 dateformatter.timeStyle = .none
 checkin_uitext.text = dateformatter.string(from: checkin_picker.date as Date)
 }else if checkout_uitext.isFirstResponder{
 checkout_uitext.endEditing(true)
 
 let dateformatter = DateFormatter()
 dateformatter.dateStyle = .long
 dateformatter.timeStyle = .none
 checkout_uitext.text = dateformatter.string(from: checkout_picker.date as Date)
 }
 }
 
 // CancelButton
 @objc func cancelPicker(){
 if checkin_uitext.isFirstResponder{
 checkin_uitext.endEditing(true)
 }else if checkout_uitext.isFirstResponder{
 checkout_uitext.endEditing(true)
 }
 }
 
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 func Calender_setup(){
 self.Calender.scrollDirection = .vertical
 self.Calender.swipeToChooseGesture.isEnabled = true
 }
 
 
 }

 
 */
