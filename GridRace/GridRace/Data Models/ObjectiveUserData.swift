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

    var correct = true
    
    var completed: Bool {

        if correct {
            if imageResponseURL != nil || textResponse != nil {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    init(id: String) {
        objectiveID = id
    }

    
   
}
