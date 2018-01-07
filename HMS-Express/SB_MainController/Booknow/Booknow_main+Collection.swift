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
        return self.listofhomestay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.listofhomestay.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Add_homestay", for: indexPath) as! Add_homestay
            return cell
        } else {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Search_Homestay_Card", for: indexPath) as! Search_Homestay_Card
            cell.homestay_name.text = self.listofhomestay[indexPath.row].get_name()
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
