//
//  HudView.swift
//  MyLocations
//
//  Created by Christian on 2/13/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class HudView: UIView {

    var text = ""

    class func hud(inView view: UIView, animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.isOpaque = false
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
        hudView.show(animated: animated)
        return hudView
    }

    override func draw(_ rect: CGRect) {
        let boxWidth: CGFloat = 112
        let boxHeight: CGFloat = 112
        let boxRect = CGRect( x: round((bounds.size.width - boxWidth) / 2), y: round((bounds.size.height - boxHeight) / 2),
            width: boxWidth, height: boxHeight)
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()

        // Draw checkmark
        let image = #imageLiteral(resourceName: "checkMark").withRenderingMode(.alwaysTemplate)
        let imagePoint = CGPoint(x: center.x - round(image.size.width / 2), y: center.y - round(image.size.height / 2) - boxHeight / 8)
        let imageView = UIImageView(frame: CGRect(x: imagePoint.x, y: imagePoint.y, width: image.size.width, height: image.size.height))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.textPrimaryColor
        addSubview(imageView)

        // Draw the text
        let attribs = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
            NSAttributedStringKey.foregroundColor: AppColors.textPrimaryColor
            ] as [NSAttributedStringKey : Any]
        let textSize = text.size(withAttributes: attribs)
        let textPoint = CGPoint( x: center.x - round(textSize.width / 2), y: imageView.center.y + round(imageView.bounds.height / 2) + 10)
        text.draw(at: textPoint, withAttributes: attribs)
    }

    // MARK:- Public methods
    func show(animated: Bool) {
        if animated {
            //pre animation
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5, animations: {
                    //post animation
                    self.alpha = 1
                    self.transform = CGAffineTransform.identity
                })
        }
    }

    func hide() {
        superview?.isUserInteractionEnabled = true
        removeFromSuperview()
    }
}
