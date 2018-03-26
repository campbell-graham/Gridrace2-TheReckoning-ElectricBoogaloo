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
    var imageViewTopConstraint: NSLayoutConstraint!
    var imageViewBottomConstraint: NSLayoutConstraint!
    var imageViewLeadingConstraint: NSLayoutConstraint!
    var imageViewTrailingConstraint: NSLayoutConstraint!

    
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
        
        //scroll view set up
        scrollView.delegate = self
        scrollView.clipsToBounds = true
        scrollView.maximumZoomScale = 5
        scrollView.minimumZoomScale = 1
        scrollView.isUserInteractionEnabled = true
        scrollView.bouncesZoom = true
        //this still doesn't want to allow it to scroll for some reason
        //let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(zoomImage))
        //scrollView.addGestureRecognizer(pinchGR)
        
        //close button set up
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(AppColors.textSecondaryColor, for: .normal)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        
        //image view set up
        imageView.contentMode = .scaleToFill
        
        //add items to view
        view.addSubview(closeButton)
        view.addSubview(scrollView)
        
        //add image to scroll view
        scrollView.addSubview(imageView)
        
        //layout constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageViewTopConstraint =  imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)

        
        NSLayoutConstraint.activate([
            //scroll view
            scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            //image view
            imageViewTopConstraint,
            imageViewBottomConstraint,
            imageViewLeadingConstraint,
            imageViewTrailingConstraint,
        
            //close button
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(scrollView.frame.size)
    }
    
    override func viewDidLayoutSubviews() {
         scrollView.contentSize = CGSize(width: imageView.frame.width, height: imageView.frame.height)
    }
    
    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let yOffset = max(0, (scrollView.bounds.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (scrollView.bounds.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
