//
//  FireBaseDownloader.swift
//  GridRace
//
//  Created by Christian on 3/29/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import Firebase

class FireBaseDownloader: ClueViewControllerDelegate {


    //reference to firebase image storgae
    let storageRef = Storage.storage().reference()

    func downloadImage(objectID: String, completion: @escaping (UIImage)->()){

        // Create a reference to the file you want to download
        let jpgRef = storageRef.child("\(objectID).JPG")
        let pngRef = storageRef.child("\(objectID).png")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        jpgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                pngRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        completion(#imageLiteral(resourceName: "eye"))
                    } else {
                        completion(UIImage(data: data!)!)
                    }
                }
            } else {
                completion(UIImage(data: data!)!)
            }
        }
    }

}
