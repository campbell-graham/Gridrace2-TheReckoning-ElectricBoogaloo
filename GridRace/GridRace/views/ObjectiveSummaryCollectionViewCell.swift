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
    let tickImageView = UIImageView()
    let crossImageView = UIImageView()
    let responseImageView = UIImageView()
    let responseTextLabel = UILabel()
    weak var delegate: ObjectiveSummaryCollectionViewCellDelegate?

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
        
        //tick and cross set up
        tickImageView.image = #imageLiteral(resourceName: "tick-new").withRenderingMode(.alwaysTemplate)
        crossImageView.image = #imageLiteral(resourceName: "cross-new").withRenderingMode(.alwaysTemplate)

        //response image view
        responseImageView.contentMode = .scaleAspectFit
        responseImageView.layer.masksToBounds = true
        responseImageView.layer.cornerRadius = contentView.layer.cornerRadius
        responseImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openLargeImage))
        responseImageView.addGestureRecognizer(tapGestureRecognizer)
        responseImageView.isUserInteractionEnabled = true

        //response text label
        responseTextLabel.layer.masksToBounds = true
        responseTextLabel.backgroundColor = AppColors.cellColor
        responseTextLabel.textColor = AppColors.textPrimaryColor
        responseTextLabel.textAlignment = .center
        responseTextLabel.layer.cornerRadius = contentView.layer.cornerRadius
        responseTextLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

       

        for view in [nameLabel, responseImageView, responseTextLabel, tickImageView, crossImageView] as! [UIView] {

                view.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(view)
        }

        NSLayoutConstraint.activate([

            //name label
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: tickImageView.leadingAnchor),
            
            //tick image view
            tickImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            tickImageView.bottomAnchor.constraint(equalTo: responseImageView.topAnchor, constant: -4),
            tickImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            tickImageView.widthAnchor.constraint(equalTo: tickImageView.heightAnchor),
            
            //cross image view
            crossImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            crossImageView.bottomAnchor.constraint(equalTo: responseImageView.topAnchor, constant: -4),
            crossImageView.trailingAnchor.constraint(equalTo: tickImageView.leadingAnchor, constant: -12),
            crossImageView.widthAnchor.constraint(equalTo: crossImageView.heightAnchor),

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
    
    @objc func openLargeImage() {
        if let image = responseImageView.image {
            delegate?.openLargeImage(image: image)
        }
    }
}

protocol ObjectiveSummaryCollectionViewCellDelegate: class {
    func openLargeImage(image: UIImage)
}
