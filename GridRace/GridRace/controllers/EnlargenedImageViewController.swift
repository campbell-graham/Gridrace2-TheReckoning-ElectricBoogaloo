//
//  EnlargenedImageViewController.swift
//  GridRace
//
//  Created by Campbell Graham on 23/3/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class EnlargenedImageViewController: UIViewController, UIScrollViewDelegate {

    let imageTextLabel = UILabel()
    let imageView = UIImageView()
    let scrollView = UIScrollView()
    var imageViewTopConstraint: NSLayoutConstraint!
    var imageViewBottomConstraint: NSLayoutConstraint!
    var imageViewLeadingConstraint: NSLayoutConstraint!
    var imageViewTrailingConstraint: NSLayoutConstraint!

    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageTextLabel.text = ""
        imageView.image = image
    }

    init(hintText: String, hintImageURL: URL? ) {

        imageTextLabel.text = hintText

        imageView.contentMode = .scaleAspectFill
        if hintImageURL != nil, let image = UIImage(contentsOfFile: hintImageURL!.path) {
            imageView.image = image
        } else {
            imageView.image = #imageLiteral(resourceName: "placeHolder")
        }
        super.init(nibName: nil, bundle: nil)

        title = "clue"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //styling
        view.backgroundColor = AppColors.backgroundColor

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeScreen) )
        
        //scroll view set up
        scrollView.delegate = self
        scrollView.clipsToBounds = true
        scrollView.maximumZoomScale = 5

        //textView Setup
        imageTextLabel.numberOfLines = 0
        imageTextLabel.textColor = AppColors.textPrimaryColor
        imageTextLabel.backgroundColor = AppColors.backgroundColor
        imageTextLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        //image view set up
        imageView.contentMode = .scaleAspectFit
        
        //add items to view
        view.addSubview(imageTextLabel)
        view.addSubview(scrollView)
        
        //add image to scroll view
        imageView.frame = scrollView.bounds
        scrollView.addSubview(imageView)
        
        //layout constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageTextLabel.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([

            //imageText
            imageTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            imageTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            imageTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8),


            //scroll view
            scrollView.topAnchor.constraint(equalTo: imageTextLabel.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imageView.frame = CGRect(origin: .zero, size: scrollView.frame.size)
        scrollView.contentSize = imageView.frame.size
        updateMinZoomScaleForSize(scrollView.frame.size)
    }
    
    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
}
