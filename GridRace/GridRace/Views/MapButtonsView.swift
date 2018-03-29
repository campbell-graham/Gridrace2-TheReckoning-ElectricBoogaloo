//
//  MapButtonsView.swift
//  GridRace
//
//  Created by Christian on 3/26/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class MapButtonsView: UIView {

    var resetMapButton = UIButton(type: UIButtonType.system)
    var showUserLocationButton = UIButton(type: UIButtonType.system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        //buttons view set up
        showUserLocationButton.setImage(#imageLiteral(resourceName: "directional_arrow").withRenderingMode(.alwaysTemplate), for: .normal)
        showUserLocationButton.imageView?.tintColor = UIColor.blue
        resetMapButton.imageView?.tintColor = UIColor.blue
        
        //layer changes/styling
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 4

        //add buttons to buttons view
        addSubview(showUserLocationButton)
        addSubview(resetMapButton)

        //layout constraints
        showUserLocationButton.translatesAutoresizingMaskIntoConstraints = false
        resetMapButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            //user location button
            showUserLocationButton.topAnchor.constraint(equalTo: self.centerYAnchor),
            showUserLocationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            showUserLocationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            showUserLocationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            //reset map button
            resetMapButton.topAnchor.constraint(equalTo: self.topAnchor),
            resetMapButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            resetMapButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            resetMapButton.bottomAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
