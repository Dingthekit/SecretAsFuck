//
//  Booking_cell.swift
//  HMS-Express
//
//  Created by Ding Zhan Chia on 17/10/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit

class Booking_cell: UITableViewCell {

    var checkin_date = Date()
    var checkout_date = Date()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate let formatter_day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    fileprivate let formatter_month: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yy"
        return formatter
    }()
    fileprivate let formatter_week: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    // IBOutlet
    @IBOutlet weak var checkin_week: UILabel!
    @IBOutlet weak var checkin_month: UILabel!
    @IBOutlet weak var checkin_day: UILabel!
    
    @IBOutlet weak var checkout_week: UILabel!
    @IBOutlet weak var checkout_month: UILabel!
    @IBOutlet weak var checkout_day: UILabel!
    
    @IBOutlet weak var customer_name: UILabel!
    @IBOutlet weak var homestay_name: UILabel!
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var Cardview: UIView!
    @IBOutlet weak var BackgroundCardView: UIView!
    
    
    func updateUI(){
        self.BackgroundCardView.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.Cardview.backgroundColor = UIColor.white
        self.Cardview.layer.cornerRadius = 1.0
        self.Cardview.layer.masksToBounds = false
        self.Cardview.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.Cardview.layer.shadowOffset = CGSize(width : 0 , height : 0)
        self.Cardview.layer.shadowOpacity = 0.8
        
    }
    
    func updateDate(){
      //  let checkin_Date = self.formatter.date(from: checkin_str)
        //let checkout_Date = self.formatter.date(from: checkout_str)
        
        self.checkin_week.text = self.formatter_week.string(from: checkin_date).uppercased()
        self.checkin_day.text = self.formatter_day.string(from: checkin_date)
        self.checkin_month.text = self.formatter_month.string(from: checkin_date).uppercased()

        self.checkout_week.text = self.formatter_week.string(from: checkout_date).uppercased()
        self.checkout_day.text = self.formatter_day.string(from: checkout_date)
        self.checkout_month.text = self.formatter_month.string(from: checkout_date).uppercased()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
