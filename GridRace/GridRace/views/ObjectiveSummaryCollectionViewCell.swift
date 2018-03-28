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
        
        //shadow
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        
        //name label
        nameLabel.textColor = AppColors.textPrimaryColor
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.setContentHuggingPriority(.required, for: .vertical)

        //response image view
        responseImageView.contentMode = .scaleAspectFill
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
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            nameLabel.trailingAnchor.constraint(equalTo: crossImageView.leadingAnchor, constant: -12),
            
            //tick image view
            tickImageView.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            tickImageView.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            tickImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            tickImageView.widthAnchor.constraint(equalTo: tickImageView.heightAnchor),
            
            //cross image view
            crossImageView.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            crossImageView.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            crossImageView.trailingAnchor.constraint(equalTo: tickImageView.leadingAnchor, constant: -18),
            crossImageView.widthAnchor.constraint(equalTo: crossImageView.heightAnchor),

            //response image view
            responseImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
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
