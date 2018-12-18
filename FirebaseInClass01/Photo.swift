//
//  Photo.swift
//  FirebaseInClass01
//
//  Created by Prerana Singh on 11/21/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//

/* File: Photo.swift
 Assignment: InClass06
 Name: Prerana Singh
 */

import Foundation

class Photo{
    var photoUrl:String = ""
    var photoKey:String = ""
    
    init(photoUrl:String,photoKey:String) {
        self.photoUrl = photoUrl
        self.photoKey = photoKey
    }
    
    init(){}
    
    var description:String{
    return "\(photoUrl),\(photoKey)"
    }
}
