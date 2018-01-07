//
//  UIEdittoggleButton.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 25/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import Foundation
import UIKit

class ToggleButton_Edit: UIButton {
    
    var isOn = true
    var NameOfButton = String()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton(NameOfButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton(NameOfButton)
    }
    
    func initButton(_ NameOfButton : String) {
        layer.borderWidth = 2.0
        layer.borderColor = Colors.HMSWhite.cgColor
        layer.cornerRadius = frame.size.height/2
        
        setTitleColor(Colors.HMSWhite, for: .normal)
        self.NameOfButton = NameOfButton
        addTarget(self, action: #selector(ToggleButton_Edit.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        
        isOn = bool
        
        let color = bool ? Colors.HMSWhite : .clear
        let title = bool ? "Done" : "Edit"
        let titleColor = bool ? Colors.HMSBlue : Colors.HMSWhite
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }
    
}


// Comment Line
struct Colors {
    static let HMSBlue = UIColor(red: 69.0/255.0, green: 114.0/255.0, blue: 148.0/255.0, alpha: 1.0)
    static let HMSWhite = UIColor(red: 254.0/255.0, green: 254.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    
}


