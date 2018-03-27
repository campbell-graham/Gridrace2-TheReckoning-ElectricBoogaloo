//
//  imageResponseView.swift
//  GridRace
//
//  Created by Christian on 3/14/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class ImageResponseView: UIView {

    let cameraImageView = UIImageView()
    let cameraLabel = UILabel()
    let responseImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        cameraImageView.image = #imageLiteral(resourceName: "camera2")
        cameraImageView.contentMode = .scaleAspectFit

        responseImageView.contentMode = .scaleAspectFit
        responseImageView.layer.cornerRadius = 16
        responseImageView.layer.masksToBounds = true
        responseImageView.contentMode = .scaleToFill
        responseImageView.isHidden = true

        cameraLabel.text = "Add Photo"
        cameraLabel.textColor = AppColors.orangeHighlightColor
        cameraLabel.textAlignment = .center
        cameraLabel.font = UIFont.boldSystemFont(ofSize: 16)

        for view in [responseImageView, cameraImageView, cameraLabel] as! [UIView] {

            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        NSLayoutConstraint.activate([

            responseImageView.topAnchor.constraint(equalTo: self.topAnchor),
            responseImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            responseImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            responseImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            cameraImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cameraImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cameraImageView.heightAnchor.constraint(equalToConstant: 80),
            cameraImageView.widthAnchor.constraint(equalToConstant: 80),

            cameraLabel.topAnchor.constraint(equalTo: cameraImageView.bottomAnchor, constant: 8),
            cameraLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cameraLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            cameraLabel.heightAnchor.constraint(equalToConstant: 20)

            ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(image: UIImage) {

        responseImageView.isHidden = false
        responseImageView.image = image

        cameraLabel.isHidden = true
        cameraImageView.isHidden = true
    }

}
