//
//  PhotosViewViewController.swift
//  FirebaseInClass01
//
//  Created by Prerana Singh on 11/14/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//
/* File: PhotosViewViewController.swift
 Assignment: InClass06
 Name: Prerana Singh
 */

import UIKit
import Firebase
import SDWebImage
//
class PhotosViewViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet var collectionview: UICollectionView!
    var UserImages = [Photo]()
     var key : String = ""
    var url =  ""
    @IBOutlet var imageview: UIImageView!
   
    override func viewWillAppear(_ animated: Bool) {
       //  self.UserImages.removeAll()
        self.collectionview.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Do any additional setup after loading the view.
        if Auth.auth().currentUser == nil{
            return
        }else{
         // self.UserImages.removeAll()
         let uid = Auth.auth().currentUser?.uid
            let photosRef = Database.database().reference().child("users").child(uid!).child("photos")
            photosRef.observe(DataEventType.value, with: {(snapshot) in
                print("\(snapshot)")
                
                if snapshot.childrenCount > 0{
                   
                     self.UserImages.removeAll()
                    for photo in snapshot.children.allObjects as! [DataSnapshot]{
                       // print(photo.value)
                        let photoKey = photo.key
                        print(photoKey)
                        if let photoObject = photo.value as? NSDictionary   {
                            let photoUrl = photoObject["imageURL"] as! String
                        print(photoUrl)
                        let photo = Photo(photoUrl: photoUrl, photoKey: photoKey)
                        self.UserImages.append(photo)
                        }
                        
                    }
                    self.collectionview.reloadData()
                   // print(self.notebooksList.description)
                   
                }
            })
        
        }
        
    }
    
   /* override func viewDidDisappear(_ animated: Bool) {
        if Auth.auth().currentUser == nil{
            return
        }else{
            let uid = Auth.auth().currentUser?.uid
            let photosRef = Database.database().reference().child("users").child(uid!).child("photos")
            photosRef.removeAllObservers()
        }
    }*/
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath)
       let photo = cell.viewWithTag(1) as! UIImageView
      //photo.image = nil
      let imageurl = UserImages[indexPath.row].photoUrl
       photo.sd_setImage(with: URL(string: imageurl), placeholderImage: nil)
     //   self.collectionview.reloadData()
        
    return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        url = UserImages[indexPath.row].photoUrl
        key = UserImages[indexPath.row].photoKey
        self.performSegue(withIdentifier: "UserPhotosToPhoto", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserPhotosToPhoto"{
            
            let photoVC = segue.destination as! PhotoViewController
            photoVC.url = url
            photoVC.photokey = key
            // print(selectedApp!.description)
            
        }
    }
    
    
    @IBAction func btnLogout(_ sender: Any) {
        
        if Auth.auth().currentUser != nil{
            do {
                try Auth.auth().signOut()
                print("signing out")
                
                performSegue(withIdentifier: "BackToLogin", sender: self)
                
               /* let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController")
                present(vc,animated: true,completion: nil)*/
                
            } catch let logoutError {
                print(logoutError.localizedDescription)
            }
        }
        
            
        
    }
    
    @IBAction func btnAddImages(_ sender: Any) {
       let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true,completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
       //print(info)
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        //authenticate user
        if Auth.auth().currentUser == nil{
            return
        }else{
            let uid = Auth.auth().currentUser?.uid
           
            let storageRef = Storage.storage().reference().child("images\(NSUUID().uuidString)/image")
            if let uploadData = selectedImageFromPicker!.pngData(){
                storageRef.putData(uploadData, metadata: nil, completion: {(metadata,error) in
                    if error != nil{
                        print("storage add data error")
                        print(error?.localizedDescription)
                        return
                    }
                    
                    print(metadata)
                    storageRef.downloadURL(completion: {(url,err) in
                        if err != nil{
                            print("download url error")
                            print(err?.localizedDescription)
                            return
                        }
                        if let imageURL = url?.absoluteString{
                            //save url to database according to UID
                            let values = ["imageURL":imageURL]
                            self.addImageURLToUser(uid: uid!,values: values as [String : AnyObject])
                        }
                        
                    })
                        
                    
                })
            }
                
                
            
        }
        
        dismiss(animated: true,completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled picker")
        dismiss(animated: true,completion: nil)
    }
    
    private func addImageURLToUser(uid:String,values:[String:AnyObject]){
        let ref = Database.database().reference(fromURL: "https://iosinclass06-bfe21.firebaseio.com/")
        let usersReference = ref.child("users").child(uid).child("photos")
        let autoID = usersReference.childByAutoId().key
        usersReference.child(autoID!).updateChildValues(values, withCompletionBlock:{ (err,ref) in
            
            if err != nil{
                print(err)
                return
            }
            print("photo url saved successfully")
            self.collectionview.reloadData()
         })
    }
    
    @IBAction func unwindToVC2(segue:UIStoryboardSegue) { }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
