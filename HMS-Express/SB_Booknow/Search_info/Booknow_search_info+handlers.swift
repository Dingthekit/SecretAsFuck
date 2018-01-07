//
//  Booknow_search_info+handlers.swift
//  HMS-Express
//
//  Created by Ding Zhan on 01/01/2018.
//  Copyright © 2018 Ding Zhan Chia. All rights reserved.
//

import UIKit

extension Booknow_search_info {
    // Dismiss Keyboard
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func handlerhideorshow_gallery(_ sender : AnyObject){
        
        // it is hidden
        if self.Photo_collection_View.isHidden{
            self.Gallery_Hide.image = UIImage(named:"Show")!
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.Photo_collection_View.isHidden = false
                sender.superview??.layoutIfNeeded()
            })

        } else {
            self.Gallery_Hide.image = UIImage(named:"Hide")!
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.Photo_collection_View.isHidden = true
                sender.superview??.layoutIfNeeded()
            })
        }
    }
    
    @objc func handlerhideorshow_info(_ sender : AnyObject){
        
        // it is hidden
        if self.Information_View.isHidden{
            self.Info_Hide.image = UIImage(named:"Show")!
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.Information_View.isHidden = false
                sender.superview??.layoutIfNeeded()
            })
            
        } else {
            self.Info_Hide.image = UIImage(named:"Hide")!
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.Information_View.isHidden = true
                sender.superview??.layoutIfNeeded()
            })
        }
        
    }
    
    @objc func handlerhideorshow_price(_ sender : AnyObject){
        
        // it is hidden
        if self.Price_view.isHidden{
            self.Price_Hide.image = UIImage(named:"Show")!
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.Price_view.isHidden = false
                sender.superview??.layoutIfNeeded()
            })
            
        } else {
            self.Price_Hide.image = UIImage(named:"Hide")!
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.Price_view.isHidden = true
                sender.superview??.layoutIfNeeded()
            })
        }
    }
}
