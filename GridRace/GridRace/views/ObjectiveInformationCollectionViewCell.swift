//
//  ObjectiveInformationCollectionViewCell.swift
//  GridRace
//
//  Created by Campbell Graham on 14/3/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class ObjectiveInformationCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let pointsLabel = UILabel()
    let descriptionLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        
        backgroundColor = AppColors.backgroundColor
        
        //label set up
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = AppColors.textPrimaryColor
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        pointsLabel.font = UIFont.systemFont(ofSize: 14, weight: .ultraLight)
        pointsLabel.textColor = AppColors.orangeHighlightColor
        pointsLabel.setContentHuggingPriority(.required, for: .vertical)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .ultraLight)
        descriptionLabel.textColor = AppColors.textSecondaryColor
        descriptionLabel.numberOfLines = 0
        
        //shadow
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(descriptionLabel)
        
        //layout constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //title label
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            //points label
            pointsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            pointsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            pointsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            //description label
            descriptionLabel.topAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
