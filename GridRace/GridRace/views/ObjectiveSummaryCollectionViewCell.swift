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
    //let pointLabel = UILabel()
    let responseImageView = UIImageView()
    let responseTextLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = false

        nameLabel.textColor = AppColors.textPrimaryColor
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.setContentHuggingPriority(.required, for: .vertical)

        responseImageView.contentMode = .scaleAspectFit
        responseImageView.layer.cornerRadius = contentView.layer.cornerRadius
        responseImageView.layer.masksToBounds = true

        responseTextLabel.layer.masksToBounds = true
        responseTextLabel.layer.cornerRadius = contentView.layer.cornerRadius
        responseTextLabel.backgroundColor = AppColors.cellColor
        responseTextLabel.textColor = AppColors.textPrimaryColor
        responseTextLabel.textAlignment = .center

       

        for view in [nameLabel, responseImageView, responseTextLabel] as! [UIView] {

                view.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(view)
        }

        NSLayoutConstraint.activate([

            //name label
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            //response image view
            responseImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            responseImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            responseImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            responseImageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            responseImageView.leadingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            responseImageView.widthAnchor.constraint(equalTo: responseImageView.heightAnchor),

            //response text view
            responseTextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            responseTextLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            responseTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            responseTextLabel.widthAnchor.constraint(equalTo: responseTextLabel.heightAnchor)

        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
