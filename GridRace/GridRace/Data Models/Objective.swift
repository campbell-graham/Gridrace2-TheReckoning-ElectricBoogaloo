//
//  Objective.swift
//  GridRace
//
//  Created by Campbell Graham on 27/2/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import MapKit

class Objective: Codable, Equatable {
   
    static func ==(lhs: Objective, rhs: Objective) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.desc != rhs.desc {
            return false
        }
        if lhs.hintImageUrl != rhs.hintImageUrl {
            return false
        }
        if lhs.hintText != rhs.hintText {
            return false
        }
        if lhs.points != rhs.points {
            return false
        }
        if lhs.latitude != rhs.latitude {
            return false
        }
        if lhs.longitude != rhs.longitude {
            return false
        }
        if lhs.answerType != rhs.answerType {
            return false
        }
        if lhs.objectiveType != rhs.objectiveType {
            return false
        }
        
        return true
    }
    
   
    let id: String
    let name: String
    let desc: String
    var hintImageUrl: URL?
    let hintText: String
    var points: Int
    let latitude: Double?
    let longitude: Double?
    let answerType: AnswerType
    let objectiveType: ObjectiveType
    var coordinate: CLLocationCoordinate2D?
    {
        if let lat = latitude, let long = longitude {
            let cord = CLLocationCoordinate2D(latitude: lat, longitude: long)
            return cord
        }
        return nil
    }
    
    
}

struct ObjectList: Codable {
    var data: [Objective]
}

enum AnswerType: String, Codable {
    case photo
    case text
    case password
}

enum ObjectiveType: String, Codable {
    case main
    case bonus
    case last
}
