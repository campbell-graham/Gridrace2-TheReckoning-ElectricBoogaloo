//
//  UIViewExtension.swift
//  GridRace
//
//  Created by Christian on 3/20/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

extension UIView {

    func takeSnapshot(bounds: CGRect) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

        drawHierarchy(in: bounds, afterScreenUpdates: true)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
