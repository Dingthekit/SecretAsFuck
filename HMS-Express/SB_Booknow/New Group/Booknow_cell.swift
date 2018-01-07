//
//  Booknow_cell.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 06/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit

class Booknow_cell: UITableViewCell {

    //labels connected
    @IBOutlet weak var homestay_label: UILabel!
    @IBOutlet weak var price_label: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
