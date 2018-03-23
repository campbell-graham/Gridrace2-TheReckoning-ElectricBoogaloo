//
//  EnlargenedImageViewController.swift
//  GridRace
//
//  Created by Campbell Graham on 23/3/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class EnlargenedImageViewController: UIViewController {
    
    let imageView = UIImageView()
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //styling
        view.backgroundColor = AppColors.backgroundColor
        
        //add items to view
        view.addSubview(imageView)
        
        //layout constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //image view
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
