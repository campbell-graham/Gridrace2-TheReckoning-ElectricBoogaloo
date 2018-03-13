//
//  TimerView.swift
//  GridRace
//
//  Created by Campbell Graham on 6/3/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class TimerView: UIView {
    
    let timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //view styling
        tintColor = AppColors.backgroundColor
        
        //label styling
        timeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        timeLabel.textColor = AppColors.greenHighlightColor
        
        addSubview(timeLabel)
        
        //layout constraints
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
