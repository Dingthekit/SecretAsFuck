//
//  Price_Calender.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 14/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import Foundation

class PriceCalendarCell: FSCalendarCell {
    
    weak var selectionLayer: CAShapeLayer!
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
   
        
        
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.init(red: 69/255, green: 114/255, blue: 148/255, alpha: 0).cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        self.shapeLayer.isHidden = false
    
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        
        let x = self.contentView.bounds.origin.x
        let y = self.contentView.bounds.origin.y + ( self.contentView.bounds.height / 8 )
        let width = self.contentView.bounds.width
        let height = self.contentView.bounds.height - ( self.contentView.bounds.height / 4 )
        
        self.selectionLayer.frame = CGRect.init(x: x, y: y, width: width, height: height)
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 3, height: self.selectionLayer.frame.width / 3)).cgPath
        }
        else if selectionType == .rightBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 3, height: self.selectionLayer.frame.width / 3)).cgPath
        }
        else if selectionType == .single {
            self.selectionLayer.frame = self.contentView.bounds
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration

        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        } else {
            
            if self.isSelected {
                self.subtitleLabel.textColor = .white
            } else {
                self.subtitleLabel.textColor = UIColor.darkGray
            }
        }
    }
    
    
}
