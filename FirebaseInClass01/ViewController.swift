//
//  ViewController.swift
//  FirebaseInClass01
//
//  Created by Shehab, Mohamed on 11/9/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//
/* File: ViewController.swift
 Assignment: InClass06
 Name: Prerana Singh
 */

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet var password: UITextField!
    @IBOutlet var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
   
    @IBAction func btnLogin(_ sender: Any) {
        guard let txtEmail = email.text , let txtPassword = password.text
            else{
                return
        }
        
        if(txtEmail == "" || txtPassword == ""){
            let alertController = UIAlertController(title: "Error", message: "Fields cannot be empty", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        Auth.auth().signIn(withEmail: txtEmail, password: txtPassword, completion: {(user,error) in
            
            if error != nil{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            //successufully logged in our user
           self.performSegue(withIdentifier: "LoginToUserPhotos", sender: self)
            
            
        })
    }
   
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
    
}

