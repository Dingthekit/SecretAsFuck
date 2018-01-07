//
//  Basic_Information_Cell.swift
//  HMS-Express
//
//  Created by Ding Zhan on 01/01/2018.
//  Copyright © 2018 Ding Zhan Chia. All rights reserved.
//

import UIKit

class Basic_Information_Cell: UITableViewCell {

    @IBOutlet var description_label: UILabel!
    @IBOutlet var title_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
