//
//  Booknow_search_info+table.swift
//  HMS-Express
//
//  Created by Ding Zhan on 01/01/2018.
//  Copyright © 2018 Ding Zhan Chia. All rights reserved.
//

import UIKit


extension Booknow_search_info {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( tableView == self.price_table ) {
            if listofdate.count == 0 { return 0 } else { return ( listofdate.count + 1 ) }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ( tableView == self.price_table ) {
            if ( indexPath.row != listofdate.count ) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "single_price", for: indexPath) as! single_price_cell
                
                cell.price_date.text = self.listofdate[indexPath.row]
                
                for price in listofprice {
                    if formatter.date(from: self.listofdate[indexPath.row]) == formatter_default.date(from: price.key) {
                        cell.price.text = String(price.value) + " MYR"
                    }
                }
                if (cell.price.text?.isEmpty)! {
                    self.isPriceEntered = true
                    cell.price.text = "0" + " MYR"
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "total_price", for: indexPath) as! total_price_cell
                var total : Int = 0
                for price in listofprice {
                    for date in listofdate{
                        if formatter.date(from: date) == formatter_default.date(from: price.key) {
                            total += Int(price.value)!
                        }
                    }
                }
                self.price = total
                cell.price.text = String(total) + " MYR"
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Basic_Information_Cell", for: indexPath) as! Basic_Information_Cell
            return cell
            
        }
    }
    
}
