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
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.text = "Test"
        
        
        //value label
        valueLabel.textColor = AppColors.orangeHighlightColor
        valueLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        valueLabel.text = "22:32:12"
        
        //add items to view
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        //layout constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //title label
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            //value label
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
