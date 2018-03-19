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
        
        self.frame = frame
        
        timeLabel.textColor = AppColors.orangeHighlightColor
        
        //set up the timer view to refresh every second
       
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            let interval = Date().timeIntervalSince(AppResources.firstLaunchDate)
            
            let ti = NSInteger(interval)
            
            let seconds = ti % 60
            let minutes = (ti / 60) % 60
            let hours = ti / 3600
            
            AppResources.timeToDisplay = NSString(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds) as String
            self.timeLabel.text = AppResources.timeToDisplay
        })
        
        
        //view styling
        tintColor = AppColors.backgroundColor
        
        addSubview(timeLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: topAnchor),
            timeLabel.widthAnchor.constraint(equalTo: widthAnchor),
            timeLabel.heightAnchor.constraint(equalTo: heightAnchor)
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
