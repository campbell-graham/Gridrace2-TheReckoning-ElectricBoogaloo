//
//  SummaryStatView.swift
//  GridRace
//
//  Created by Campbell Graham on 23/3/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class SummaryStatView: UIView {

    let titleLabel = UILabel()
    let valueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //styling
        backgroundColor = AppColors.cellColor
        layer.cornerRadius = 10
        
        //title label
        titleLabel.textColor = AppColors.textPrimaryColor
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.text = "Test"
        
        //value label
        valueLabel.textColor = AppColors.orangeHighlightColor
        valueLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.8
        valueLabel.text = "22:32:12"
        
        //add items to view
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        //layout constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //title label
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            //value label
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
