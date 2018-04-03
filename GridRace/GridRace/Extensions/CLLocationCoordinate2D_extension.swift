//
//  CLLocationCoordinate2D_extension.swift
//  GridRace
//
//  Created by Christian on 3/26/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import MapKit

extension CLLocationCoordinate2D {

    static func ==(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool { 

        return ( left.latitude == right.latitude && left.longitude == right.longitude)
    }
}
