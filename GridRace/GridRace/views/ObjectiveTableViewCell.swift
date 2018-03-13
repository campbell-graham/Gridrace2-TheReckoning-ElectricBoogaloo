//
//  ObjectiveTableViewCell.swift
//  GridRace
//
//  Created by Campbell Graham on 26/2/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class ObjectiveTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let pointsLabel = UILabel()
    let circlePointsImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //cell styling
        backgroundColor = AppColors.cellColor
        let bgView = UIView()
        bgView.backgroundColor = AppColors.greenHighlightColor
        selectedBackgroundView = bgView
        
        //image setup
        circlePointsImageView.image = #imageLiteral(resourceName: "circle").withRenderingMode(.alwaysTemplate)
        circlePointsImageView.tintColor = AppColors.greenHighlightColor
        
        //label styling
        titleLabel.textColor = AppColors.textPrimaryColor
        pointsLabel.textColor = AppColors.greenHighlightColor
        pointsLabel.textAlignment = .center
        
        //add items to cell
        addSubview(titleLabel)
        addSubview(pointsLabel)
        addSubview(circlePointsImageView)
        
        //layout constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        circlePointsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //title label
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            //star image view
            circlePointsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            circlePointsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circlePointsImageView.widthAnchor.constraint(equalToConstant: 40),
            circlePointsImageView.heightAnchor.constraint(equalToConstant: 40),
            
            //points label
            pointsLabel.centerXAnchor.constraint(equalTo: circlePointsImageView.centerXAnchor),
            pointsLabel.centerYAnchor.constraint(equalTo: circlePointsImageView.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
