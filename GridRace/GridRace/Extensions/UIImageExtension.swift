//
//  UIImageExtension.swift
//  GridRace
//
//  Created by Christian on 2/27/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(withBounds bounds: CGSize) -> UIImage {
        let horizontalRatio = bounds.width / size.width
        let verticalRatio = bounds.height / size.height
        let ratio = min(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        //let newSize = CGSize(width: bounds.width, height: bounds.height)

        UIGraphicsBeginImageContextWithOptions(newSize, true, UIScreen.main.scale)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
