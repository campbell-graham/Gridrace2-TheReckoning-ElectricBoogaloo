//
//  ObjectiveCollectionViewCell.swift
//  GridRace
//
//  Created by Christian on 3/8/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class ObjectiveSummaryCollectionViewCell: UICollectionViewCell {

    let nameLabel = UILabel()
    let descLabel = UITextView()
    //let pointLabel = UILabel()
    let responseImageView = UIImageView()
    let responseTextView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = false

        nameLabel.textColor = AppColors.textPrimaryColor
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)

        descLabel.backgroundColor = contentView.backgroundColor
        descLabel.textColor = AppColors.textPrimaryColor
        descLabel.isEditable = false

        responseImageView.contentMode = .scaleAspectFit
        responseImageView.layer.cornerRadius = contentView.layer.cornerRadius
        responseImageView.layer.masksToBounds = true

        responseTextView.layer.masksToBounds = true
        responseTextView.isEditable = false
        responseTextView.isEditable = false
        responseTextView.layer.cornerRadius = contentView.layer.cornerRadius

       

        for view in [nameLabel, descLabel, responseImageView, responseTextView] as! [UIView] {

                view.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(view)
        }

        NSLayoutConstraint.activate([

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 44),

            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descLabel.heightAnchor.constraint(equalToConstant: 65),

            responseImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            responseImageView.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16),
            responseImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            responseImageView.widthAnchor.constraint(equalTo: responseImageView.heightAnchor),

            responseTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            responseTextView.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16),
            responseTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            responseTextView.widthAnchor.constraint(equalTo: responseTextView.heightAnchor)

        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
