//
//  PhotoViewController.swift
//  FirebaseInClass01
//
//  Created by Prerana Singh on 11/14/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//
/* File: PhotoViewController.swift
 Assignment: InClass06
 Name: Prerana Singh
 */

import UIKit
import SDWebImage
import Firebase

class PhotoViewController: UIViewController {

   
    @IBOutlet var imageView: UIImageView!
    var url = ""
    var photokey = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(deletePhoto))
        navigationItem.rightBarButtonItem = button
        imageView.sd_setImage(with: URL(string: url), placeholderImage: nil)
        print(photokey)
        // Do any additional setup after loading the view.
    }
    
    @objc func deletePhoto(sender:UIButton){
        let alertController = UIAlertController(title: "Photo Delete", message: "Do you want to delete this photo?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            //delete image
            print("image to be deleted")
            if Auth.auth().currentUser == nil{
                return
            }else{
                let key = self.photokey
                let uid = Auth.auth().currentUser?.uid
                let photosRef = Database.database().reference().child("users").child(uid!).child("photos")
                photosRef.child(self.photokey).removeValue()
                
                //removing from storage
                let storageRef = Storage.storage().reference(forURL: self.url)
                storageRef.delete { error in
                    if let error = error {
                        print(error)
                    } else {
                        print("file deleted successfully")
                        //unwind segue to be done here
                        self.performSegue(withIdentifier: "BackToUserPhotos", sender: self)
                    }
                }
            }
                
            
        })
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToUserPhotos"{
            let unwindPhotos = segue.destination as! PhotosViewViewController
            if let idx = unwindPhotos.UserImages.index(where: { $0.photoKey == photokey }) {
                unwindPhotos.UserImages.remove(at: idx)
            }
            
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
