//
//  AppResources.swift
//  GridRace
//
//  Created by Campbell Graham on 26/2/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit


struct AppColors {
    static var textPrimaryColor = #colorLiteral(red: 0.9503886421, green: 0.9503886421, blue: 0.9503886421, alpha: 1)
    static var textSecondaryColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    static var cellColor = #colorLiteral(red: 0.1882352941, green: 0.2431372549, blue: 0.3137254902, alpha: 1)
    static var backgroundColor = #colorLiteral(red: 0.137254902, green: 0.2039215686, blue: 0.2823529412, alpha: 1)
    static var greenHighlightColor = #colorLiteral(red: 0.07450980392, green: 0.8078431373, blue: 0.4, alpha: 1)
    static var starPointsColor = #colorLiteral(red: 0.9176470588, green: 1, blue: 0.3607843137, alpha: 1)
    static var orangeHighlightColor = #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1)
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
    
    
    class ObjectiveData {
        var objectives = [Objective]()
        var data = [ObjectiveUserData]()
        
        private init() {}
        
        static let sharedObjectives = ObjectiveData()
    }
    
}





