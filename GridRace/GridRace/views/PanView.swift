//
//  PanView.swift
//  GridRace
//
//  Created by Christian on 3/2/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class PanView: UIView {

    let touchView = UIView()


    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = AppColors.cellColor

        touchView.backgroundColor = AppColors.textPrimaryColor
        touchView.layer.cornerRadius = 8
        touchView.layer.masksToBounds = false

        touchView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(touchView)

        NSLayoutConstraint.activate([
            touchView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            touchView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            touchView.heightAnchor.constraint(equalToConstant: 10),
            touchView.widthAnchor.constraint(equalToConstant: 64),
        ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
