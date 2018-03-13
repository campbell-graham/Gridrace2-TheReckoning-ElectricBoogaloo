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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.text = "Hey how's it going"
        
        layer.cornerRadius = 10
        
        backgroundColor = AppColors.backgroundColor
        
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
