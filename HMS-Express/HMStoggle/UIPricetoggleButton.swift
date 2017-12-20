//
//  UIPricetoggleButton.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 27/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import Foundation
import UIKit

class UIPriceToggleButton: UIButton {
    
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
        layer.borderColor = Colors.HMSBlue.cgColor
        layer.cornerRadius = frame.size.height/2
        
        setTitleColor(Colors.HMSBlue, for: .normal)
        self.NameOfButton = NameOfButton
        addTarget(self, action: #selector(ToggleButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        
        isOn = bool
        
        let color = bool ? Colors.HMSBlue : .clear
        let title = bool ? "Paid" : "Unpaid"
        let titleColor = bool ? .white : Colors.HMSBlue
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }
    
    
}

