//
//  textFieldView.swift
//  GridRace
//
//  Created by Christian on 2/28/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class TextResponseView: UIView {

    let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        textLabel.textAlignment = .center
        textLabel.backgroundColor = AppColors.cellColor
        textLabel.textColor = AppColors.textPrimaryColor
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 44)
        ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
