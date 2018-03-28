//
//  ObjectivesProgressView.swift
//  GridRace
//
//  Created by Christian on 3/28/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class ObjectivesProgressView: UIView {

    let progressLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.frame = frame

        progressLabel.textColor = AppColors.orangeHighlightColor
        progressLabel.text = "10/100"


        //view styling
        tintColor = AppColors.backgroundColor

        addSubview(progressLabel)

        progressLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressLabel.topAnchor.constraint(equalTo: topAnchor),
            progressLabel.widthAnchor.constraint(equalTo: widthAnchor),
            progressLabel.heightAnchor.constraint(equalTo: heightAnchor)
            ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
