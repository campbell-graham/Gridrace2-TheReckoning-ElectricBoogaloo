//
//  EnlargenedImageViewController.swift
//  GridRace
//
//  Created by Campbell Graham on 23/3/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class EnlargenedImageViewController: UIViewController, UIScrollViewDelegate {
    
    let imageView = UIImageView()
    let scrollView = UIScrollView()
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
        
        //image view set up
        imageView.isUserInteractionEnabled = true
        
        //scroll view set up
        scrollView.delegate = self
        scrollView.clipsToBounds = true
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 1
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height * 2)
        scrollView.isUserInteractionEnabled = true
        scrollView.bouncesZoom = true
        //this still doesn't want to allow it to scroll for some reason
        scrollView.isScrollEnabled = true
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(zoomImage))
        scrollView.addGestureRecognizer(pinchGR)
        
        //close button set up
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(AppColors.textSecondaryColor, for: .normal)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        
        //add items to view
        view.addSubview(closeButton)
        view.addSubview(scrollView)
        
        //add image to scroll view
        scrollView.addSubview(imageView)
        
        //layout constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //scroll view
            scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            //image view
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            //close button
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
    }
    
    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func zoomImage(_ sender: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
