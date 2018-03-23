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
    let markImageView = UIImageView()
    let responseImageView = UIImageView()
    let responseTextLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = AppColors.cellColor
        
        //name label
        nameLabel.textColor = AppColors.textPrimaryColor
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.setContentHuggingPriority(.required, for: .vertical)

        //response image view
        responseImageView.contentMode = .scaleAspectFit
        responseImageView.layer.masksToBounds = true
        responseImageView.layer.cornerRadius = contentView.layer.cornerRadius
        responseImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        //response text label
        responseTextLabel.layer.masksToBounds = true
        responseTextLabel.backgroundColor = AppColors.cellColor
        responseTextLabel.textColor = AppColors.textPrimaryColor
        responseTextLabel.textAlignment = .center
        responseTextLabel.layer.cornerRadius = contentView.layer.cornerRadius
        responseTextLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

       

        for view in [nameLabel, responseImageView, responseTextLabel, markImageView] as! [UIView] {

                view.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(view)
        }

        NSLayoutConstraint.activate([

            //name label
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: markImageView.leadingAnchor),
            
            //mark image view
            markImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            markImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            markImageView.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            markImageView.widthAnchor.constraint(equalTo: markImageView.heightAnchor),

            //response image view
            responseImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            responseImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            responseImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            responseImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),

            //response text view
            responseTextLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            responseTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            responseTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            responseTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),

        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
