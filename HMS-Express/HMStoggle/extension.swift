//
//  uitext_extension.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 16/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import Foundation
import Swift
import UIKit


// UITextField
extension UITextField {
    
    func useUnderLine() {
        
        self.layer.removeAllAnimations()

        let border = CALayer()
        let borderWidth = CGFloat(2.0)
        border.borderColor = UIColor.init(red: 84/255, green: 140/255, blue: 184/255, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func useUnderLine_whileediting() {
        
        self.layer.removeAllAnimations()
        
        let border = CALayer()
        let borderWidth = CGFloat(2.0)
        border.borderColor = UIColor.init(red: 35/255, green: 59/255, blue: 77/255, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}


// String
extension String {
    
    var isNumber : Bool {
        get {
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted ) == nil
        }
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

extension UIAlertController {
    func isValidPrice(_ price: String) -> Bool {
        return !price.isEmpty && price.isNumber
    }
    
    @objc func textDidChangeInLoginAlert() {
        if let price = textFields?[0].text,
            let action = actions.last {
            action.isEnabled = isValidPrice(price)
        }
    }
}
