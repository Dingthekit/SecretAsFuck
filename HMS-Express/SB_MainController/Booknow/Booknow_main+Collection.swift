//
//  Booknow_main+Collection.swift
//  HMS-Express
//
//  Created by Ding Zhan on 29/12/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit

extension booknow_main {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.listofhomestay.isEmpty {
            return 1
        }
        return self.listofhomestay.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.listofhomestay.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Add_homestay", for: indexPath) as! Add_homestay
            return cell
        } else {

            if self.listofhomestay.count != indexPath.row {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Search_Homestay_Card", for: indexPath) as! Search_Homestay_Card
                
                let homestay_info = self.listofhomestay[indexPath.row] as! [ String : AnyObject ]
                
                // Get Name
                let HMI_1 =  Homestay_schema1.init(listitem: (homestay_info["HMI_1"] as? [ String : String ])!)
                cell.homestay_name.text = HMI_1.get_name()
                
                
                // Get Image
                let images = homestay_info["Images"] as! [ String : String ]
                if let cover_image_url = images["IMG1"] {
                    cell.image_view.loadImageUsingCacheWithURlString(urlString: cover_image_url)
                }
                cell.image_view.contentMode = .scaleAspectFill
                
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Add_homestay", for: indexPath) as! Add_homestay
                cell.no_homestay_info.text = "Add more Homestay?!" 
                return cell
            }

        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
