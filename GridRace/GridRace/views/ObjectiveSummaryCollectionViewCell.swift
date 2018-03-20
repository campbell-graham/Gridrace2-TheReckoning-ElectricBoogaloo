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
    let responseTextView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = false

        nameLabel.textColor = AppColors.textPrimaryColor
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)

        responseImageView.contentMode = .scaleAspectFit
        responseImageView.layer.cornerRadius = contentView.layer.cornerRadius
        responseImageView.layer.masksToBounds = true

        responseTextView.layer.masksToBounds = true
        responseTextView.isEditable = false
        responseTextView.layer.cornerRadius = contentView.layer.cornerRadius
        responseTextView.backgroundColor = AppColors.cellColor
        responseTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        responseTextView.textColor = AppColors.textPrimaryColor

       

        for view in [nameLabel, responseImageView, responseTextView] as! [UIView] {

                view.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(view)
        }

        NSLayoutConstraint.activate([

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 44),

            responseImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            responseImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            responseImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            responseImageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            responseImageView.leadingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            responseImageView.widthAnchor.constraint(equalTo: responseImageView.heightAnchor),

            responseTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            responseTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            responseTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            responseTextView.widthAnchor.constraint(equalTo: responseTextView.heightAnchor)

        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
