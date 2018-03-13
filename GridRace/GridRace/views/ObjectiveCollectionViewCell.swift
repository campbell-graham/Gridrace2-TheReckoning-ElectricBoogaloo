//
//  ObjectiveCollectionViewCell.swift
//  GridRace
//
//  Created by Christian on 3/8/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class ObjectiveCollectionViewCell: UICollectionViewCell {

    let nameLabel = UILabel()
    let descLabel = UITextView()
    //let pointLabel = UILabel()
    let responseImageView = UIImageView()
    let responseTextView = UITextView()
    let checkMarkImageView = UIImageView()
    let crossImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = AppColors.cellColor
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = false

        nameLabel.textColor = AppColors.textPrimaryColor
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)

        descLabel.backgroundColor = contentView.backgroundColor
        descLabel.textColor = AppColors.textPrimaryColor
        descLabel.isEditable = false

        responseImageView.contentMode = .scaleAspectFit

        responseTextView.layer.cornerRadius = 15
        responseTextView.layer.masksToBounds = true
        responseTextView.isEditable = false
        responseTextView.isEditable = false

        checkMarkImageView.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        checkMarkImageView.image = #imageLiteral(resourceName: "checkMark2").withRenderingMode(.alwaysTemplate)
        checkMarkImageView.contentMode = .scaleAspectFit
        crossImageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        crossImageView.image = #imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate)
        crossImageView.contentMode = .scaleAspectFit

        for view in [nameLabel, descLabel, responseImageView, responseTextView,
            checkMarkImageView, crossImageView] as! [UIView] {

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
            responseImageView.widthAnchor.constraint(equalToConstant: (contentView.frame.width * 0.7) ),
            responseImageView.heightAnchor.constraint(equalTo: responseImageView.widthAnchor, multiplier: 0.5 ),

            responseTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            responseTextView.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16),
            responseTextView.widthAnchor.constraint(equalToConstant: (contentView.frame.width * 0.7) ),
            responseTextView.heightAnchor.constraint(equalTo: responseTextView.widthAnchor, multiplier: 0.5 ),

            crossImageView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
            crossImageView.topAnchor.constraint(equalTo: responseImageView.bottomAnchor, constant: 8),
            crossImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            crossImageView.widthAnchor.constraint(equalToConstant: (contentView.frame.width * 0.2) ),
            crossImageView.heightAnchor.constraint(equalTo: crossImageView.widthAnchor),

            checkMarkImageView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            checkMarkImageView.topAnchor.constraint(equalTo: crossImageView.topAnchor),
            checkMarkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            checkMarkImageView.widthAnchor.constraint(equalToConstant: (contentView.frame.width * 0.2) ),
            checkMarkImageView.heightAnchor.constraint(equalTo: crossImageView.widthAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
