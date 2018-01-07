//
//  Homestay_final.swift
//  HMS-Express
//
//  Created by Ding Zhan on 27/12/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage
import NVActivityIndicatorView

class Homestay_final: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {


    // Variable
    @IBOutlet var picture_collection: UICollectionView!
    var homestay_info_1 = Homestay_schema1()
    var homestay_info_2 = Homestay_schema2()
    var homestay_info_3 = Homestay_schema3()
    
    fileprivate var key = String()
    
    fileprivate var curruser = Employee()
    var list_of_image = [ UIImage ]()
    fileprivate var image_dict : [ String : String] = [:]
    @IBOutlet var add_image: UIImageView!
    
    //fileprivate var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    fileprivate var sampleindicator : NVActivityIndicatorView = NVActivityIndicatorView(frame:  CGRect(x: UIScreen.main.bounds.size.width * 0.5 - 25 , y: UIScreen.main.bounds.size.height * 0.5 - 25, width: 50, height: 50), type: .ballRotateChase , color: UIColor.black , padding: CGFloat(0))
    fileprivate var animation_switch : Bool = true {
        didSet {
            if animation_switch {
                self.sampleindicator.startAnimating()
                self.view.addSubview(self.sampleindicator)
            } else {
                self.sampleindicator.stopAnimating()
                self.view.subviews[self.view.subviews.capacity - 1].removeFromSuperview()
            }
        }
    }
    fileprivate var upload_done : Bool = true {
        didSet {
            if upload_done {
                animation_switch = false
                
                // Final_ value to submit
                let homestay_ref = Database.database().reference().child("Homestay").child(self.curruser.get_CID()).child(key)
                let final_value : [ String : Any ] = [ "Name" : self.homestay_info_1.get_name(),
                                                       "HID" : key,
                                                       "HMI_1" : self.homestay_info_1.convert_to_list(),
                                                       "HMI_2" : self.homestay_info_2.convert_to_list(),
                                                       "HMI_3" : self.homestay_info_3.convert_to_list(),
                                                       "Images" : image_dict]
                
                homestay_ref.setValue(final_value) { (error, ref) -> Void in
                    if error != nil {
                        print(error as Any)
                        return
                    } else {
                        self.animation_switch = false
                        let sb = UIStoryboard( name : "MainController", bundle : nil )
                        let vc = sb.instantiateViewController(withIdentifier: "Home") as! UITabBarController
                        vc.selectedIndex = 2
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    fileprivate var upload_count : Int = 0 {
        didSet {
            if upload_count == ( self.list_of_image.count + 1 ) {
                self.upload_done = true
            } else {
                let storageref = Storage.storage().reference().child(self.curruser.get_CID()).child(key).child("IMG" + String(upload_count))
                
                if let uploadData = UIImagePNGRepresentation(self.list_of_image[upload_count - 1].resized(withPercentage: 0.4)!) {
                    let uploadtask = storageref.putData(uploadData, metadata: nil, completion:
                    { (metadata, error) in
                        if error != nil {
                            print(error as Any)
                            return
                        }
                    })
                    
                    uploadtask.observe(.progress){ snapshot in
                        let doneprogress : Double  = 100.0 *  Double(self.upload_count - 1 ) /  Double(self.list_of_image.count)
                        self.progress = 100.0 * Double(snapshot.progress!.completedUnitCount)
                            / Double(snapshot.progress!.totalUnitCount) / Double(self.list_of_image.count) + doneprogress
                    }
                    uploadtask.observe(.success) { snapshot in
                        if let image_url = snapshot.metadata?.downloadURL()?.absoluteString{
                            self.image_dict["IMG" + String(self.upload_count)] = image_url
                            print(self.image_dict)
                        }
                        self.upload_count += 1
                    }
                }
            }
        }
    }
    fileprivate var progress : Double = 0 {
        didSet {
            print("Progress : \(progress)")
        }
    }
    
    
    @IBAction func confirm_button(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "", message: "Everything is entered correctly?", preferredStyle: .alert)
        
        // Confirmation Action. Date: 30 Sept 2017
        let confirmAction = UIAlertAction(title: "Confirm!", style: .default , handler: { (action)-> Void in
            self.animation_switch = true
            self.start_queue()
        })
        // Cancelation Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add 2 Actions
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func register_info(){
        
        let CID : String = self.curruser.get_CID()
        key = Database.database().reference().child("Homestay").child(CID).childByAutoId().key
        
        self.homestay_info_1.set_hid(key)
        self.homestay_info_2.set_hid(key)
        self.homestay_info_3.set_hid(key)
        
        // save data into the things
        print("Total image : \(self.list_of_image) ")
        if !self.list_of_image.isEmpty {
            self.upload_count = 1
        } else {
            self.upload_done = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handlerSelectProfileImageView(_:)))
        self.add_image.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list_of_image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picture_cell", for: indexPath) as! Picture_Cell
        cell.sample_image.image = list_of_image[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "Do you want to delete selected photo?", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default) { (action) in
            self.list_of_image.remove(at: indexPath.row)
            self.picture_collection.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        
        myActionSheet.addAction(deleteAction)
        myActionSheet.addAction(cancelAction)

        // present the action sheet
        self.present(myActionSheet, animated: true, completion: nil)
        
    }
    
    // Function: start_queue -> Void
    func start_queue(){
        let ref = Database.database().reference(withPath: "System_User")
        let uid : String = (Auth.auth().currentUser?.uid)!
        ref.child(uid).observe(.value, with: { snapshot in
            if snapshot.exists(){
                self.curruser = Employee.init(snapshot: snapshot)!
                self.register_info()
            }
        })
    }
    
}

