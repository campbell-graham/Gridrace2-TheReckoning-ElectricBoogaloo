//
//  ObjectiveUserData.swift
//  GridRace
//
//  Created by Campbell Graham on 5/3/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class ObjectiveUserData: Codable {
    
    let objectiveID: String
    var adjustedPoints: Int?
   
    var imageResponseURL: URL?
    var textResponse: String?

    var correct = false
    
    var completed: Bool {

        if imageResponseURL != nil || textResponse != nil {
            correct = true
            return true
        } else {
            return false
        }
    }
    
    init(id: String) {
        objectiveID = id
    }

    
   
}
