//
//  Homestay_TableViewCell.swift
//  
//
//  Created by Ding Zhan Chia on 30/09/2017.
//

import UIKit

class Homestay_TableViewCell: UITableViewCell {
    
    //labels connected
    @IBOutlet var homestay_image: UIImageView!
    @IBOutlet weak var homestay_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
