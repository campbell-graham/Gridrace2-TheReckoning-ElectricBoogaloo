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
    let closeButton = UIButton()
    
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
        
        //close button set up
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(AppColors.textSecondaryColor, for: .normal)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        
        //add items to view
        view.addSubview(imageView)
        view.addSubview(closeButton)
        
        //layout constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //image view
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            //close button
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
    }
    
    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
