//
//  AppResources.swift
//  GridRace
//
//  Created by Campbell Graham on 26/2/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


struct AppColors {
    static var textPrimaryColor = #colorLiteral(red: 0.9503886421, green: 0.9503886421, blue: 0.9503886421, alpha: 1)
    static var textSecondaryColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    static var cellColor = #colorLiteral(red: 0.2039215686, green: 0.2470588235, blue: 0.2941176471, alpha: 1)
    static var backgroundColor = #colorLiteral(red: 0.1647058824, green: 0.1960784314, blue: 0.2352941176, alpha: 1)
    static var greenHighlightColor = #colorLiteral(red: 0.07450980392, green: 0.8078431373, blue: 0.4, alpha: 1)
    static var starPointsColor = #colorLiteral(red: 0.9176470588, green: 1, blue: 0.3607843137, alpha: 1)
}

struct AppResources {
    static func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
    
    static var firstLaunchDate: Date {
        return UserDefaults.standard.object(forKey: "FirstLaunchDate") as! Date
    }
    
    static var timeToDisplay: String = "00:00:00"
    
    
    static func returnDownloadedObjectives(completion: @escaping (([Objective]) -> ())) {
        //download if doesn't exist already
        
        var downloadedObjectives = [Objective]()
        
        
        
        let ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            do {
                if let dict = snapshot.value as? [String: Any] {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonDecoder = JSONDecoder()
                    downloadedObjectives = try jsonDecoder.decode(ObjectList.self, from: data).data
                    completion(downloadedObjectives)
                }
            } catch {
                print(error)
            }
        })
        
        
        
    }
    
    class ObjectiveData {
        var objectives = [Objective]()
        var data = [ObjectiveUserData]()
        
        private init() {}
        
        static let sharedObjectives = ObjectiveData()
    }
    
}





