//
//  UItoggleButton.swift
//  ToggleButton
//
//  Created by Ding Zhan Chia on 22/09/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit

class ToggleButton: UIButton {
    
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
        layer.borderColor = Colors.twitterBlue.cgColor
        layer.cornerRadius = frame.size.height/2
        
        setTitleColor(Colors.twitterBlue, for: .normal)
        self.NameOfButton = NameOfButton
        addTarget(self, action: #selector(ToggleButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        
        isOn = bool
        
        let color = bool ? Colors.twitterBlue : .clear
        let title = bool ? self.NameOfButton : self.NameOfButton
        let titleColor = bool ? .white : Colors.twitterBlue
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }
    
    
}

