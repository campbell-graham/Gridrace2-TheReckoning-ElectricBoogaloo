//
//  FireBaseDownloader.swift
//  GridRace
//
//  Created by Christian on 3/29/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import FirebaseStorage

class FireBaseDownloader {


    //reference to firebase image storgae
    let storageRef = Storage.storage().reference()

    func downloadImage(objectiveID: String){

        // Create a reference to the file you want to download
        let jpgRef = storageRef.child("\(objectiveID).JPG")
        let pngRef = storageRef.child("\(objectiveID).png")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        jpgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
                pngRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error)
                        return
                    } else {
                        self.saveImage(objectiveID: objectiveID, image: UIImage(data: data!)!)
                    }
                }
            } else {
                self.saveImage(objectiveID: objectiveID, image: UIImage(data: data!)!)
            }
        }
    }

    func saveImage(objectiveID: String, image: UIImage) {

        let imageData = UIImageJPEGRepresentation(image, 1)
        let imageFilePath = AppResources.documentsDirectory().appendingPathComponent("HintImage_\(objectiveID).jpeg")
        do {
            try imageData?.write(to: imageFilePath)
            guard let data = AppResources.ObjectiveData.sharedObjectives.data.first(where: {$0.objectiveID == objectiveID}) else { return }
            data.hintImageURL = imageFilePath

        } catch {
            print("Failed to save image")
        }
    }

}
