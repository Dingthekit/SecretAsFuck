//
//  Booknow_search_info+collection.swift
//  HMS-Express
//
//  Created by Ding Zhan on 01/01/2018.
//  Copyright © 2018 Ding Zhan Chia. All rights reserved.
//

import UIKit

extension Booknow_search_info {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.Photo_collection {
            if self.listofimage.isEmpty {
                return 1
            }
            return self.listofimage.count
        } else if collectionView == self.amenities {
            if self.listofamenities.isEmpty {
                return 0
            } else {
                return self.listofamenities.count
            }
        } else if collectionView == self.info_collection {
            if self.listofinfo.isEmpty {
                return 0
            } else {
                return self.listofinfo.count
            }
        } else {
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.Photo_collection {
            if self.listofimage.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "No_Photo_Card", for: indexPath) as! No_Photo_Card
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gallery_photo_collection_cell", for: indexPath) as! Gallery_photo_collection_cell
                
                cell.sample_photo.loadImageUsingCacheWithURlString(urlString: self.listofimage[indexPath.row])
                cell.sample_photo.contentMode = .scaleAspectFill
                
                return cell
            }
        } else if collectionView == self.amenities {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Amenities_Cell", for: indexPath) as! Amenities_Cell
                cell.amenities_title.text = self.listofamenities[indexPath.row]
                return cell
        } else if collectionView == self.info_collection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Info_Cell", for: indexPath) as! Info_Cell
            cell.title_label.text = self.listofinfo[indexPath.row]
            cell.description_label.text = self.listofdesc[self.listofinfo[indexPath.row]]
            return cell
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
    }

}
