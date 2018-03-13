//
//  CustomTabBarController.swift
//  GridRace
//
//  Created by Campbell Graham on 7/3/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    let timerView = TimerView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tab bar styling
        tabBar.tintColor = AppColors.greenHighlightColor
        tabBar.barTintColor = AppColors.backgroundColor
        
        //set up the timer view to refresh every second
        timerView.timeLabel.text = AppResources.timeToDisplay
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            let interval = Date().timeIntervalSince(AppResources.firstLaunchDate)
            
            let ti = NSInteger(interval)
            
            let seconds = ti % 60
            let minutes = (ti / 60) % 60
            let hours = ti / 3600
            
            AppResources.timeToDisplay = NSString(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds) as String
            self.timerView.timeLabel.text = AppResources.timeToDisplay
        })
        
        //create two main controllers for places and bonus
        let placesViewController = ObjectiveTableViewController(title: "Places", tabBarImage: #imageLiteral(resourceName: "directional_arrow"), dataCategory: ObjectiveCategory(rawValue: "places"), coreObjectData: AppResources.ObjectiveData.sharedPlaces)
        let bonusViewController = ObjectiveTableViewController(title: "Bonus", tabBarImage: #imageLiteral(resourceName: "clock_outline"), dataCategory: .bonus, coreObjectData: AppResources.ObjectiveData.sharedBonus)
        
        //add controllers to self
        viewControllers = [UINavigationController(rootViewController: placesViewController), UINavigationController(rootViewController: bonusViewController)]
        
        //add timer view to the tab bar
        tabBar.addSubview(timerView)
        
        //layout constaints
        timerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timerView.centerXAnchor.constraint (equalTo: tabBar.centerXAnchor),
            timerView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
            timerView.heightAnchor.constraint(equalToConstant: tabBar.bounds.height),
            timerView.widthAnchor.constraint(equalToConstant: tabBar.frame.width * 0.3)
            ])
    }
}
