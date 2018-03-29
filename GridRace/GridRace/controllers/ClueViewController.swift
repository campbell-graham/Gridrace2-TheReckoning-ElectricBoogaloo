//
//  ClueView.swift
//  GridRace
//
//  Created by Christian on 2/27/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import Firebase

protocol ClueViewControllerDelegate {

    func downloadImage(objectID: String, completion: @escaping  (UIImage)->())
}

class ClueViewController: UIViewController {

    let transparentBackgroundView = GradientView()
    let clueBackgroundView = UIView()
    let clueImageView = UIImageView()
    let clueLabel = UILabel()
    var objectID: String

    var delegate: ClueViewControllerDelegate? {

        didSet {
            delegate?.downloadImage(objectID: objectID ,completion: setImage)
        }
    }

    init(hintText: String, objectID: String ) {

        self.objectID = objectID
        clueLabel.text = hintText
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = .clear

        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        transparentBackgroundView.addGestureRecognizer(tapGestureRecogniser)

        clueBackgroundView.layer.cornerRadius = 10
        clueBackgroundView.layer.masksToBounds = false
        clueBackgroundView.backgroundColor = AppColors.cellColor

        clueLabel.textColor = AppColors.textPrimaryColor
        clueLabel.numberOfLines = 0

        clueImageView.contentMode = .scaleAspectFill
        clueImageView.image = #imageLiteral(resourceName: "eye")
        clueImageView.layer.cornerRadius = 15
        clueImageView.layer.masksToBounds = true

        for v in [transparentBackgroundView, clueBackgroundView] {
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }

        for v in [clueLabel, clueImageView] {
            v.translatesAutoresizingMaskIntoConstraints = false
            clueBackgroundView.addSubview(v)
        }

        NSLayoutConstraint.activate([

            transparentBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            transparentBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transparentBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transparentBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            clueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: (view.frame.height) * 0.2),
            clueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            clueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            clueBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (-view.frame.height) * 0.2),

            clueImageView.topAnchor.constraint(equalTo: clueBackgroundView.topAnchor, constant: 16),
            clueImageView.leadingAnchor.constraint(equalTo: clueBackgroundView.leadingAnchor, constant: 16),
            clueImageView.trailingAnchor.constraint(equalTo: clueBackgroundView.trailingAnchor, constant: -16),

            clueLabel.topAnchor.constraint(equalTo: clueImageView.bottomAnchor, constant: 20),
            clueLabel.leadingAnchor.constraint(equalTo: clueBackgroundView.leadingAnchor, constant: 10),
            clueLabel.trailingAnchor.constraint(equalTo: clueBackgroundView.trailingAnchor, constant: -10),
            clueLabel.bottomAnchor.constraint(equalTo: clueBackgroundView.bottomAnchor, constant: -20)
        ])
    }

    @objc func dismiss(_ sender: UITapGestureRecognizer) {

        dismiss(animated: true, completion: nil)
    }

    func setImage (image: UIImage) {
        clueImageView.image = image
        clueImageView.contentMode = .scaleAspectFill
    }



}
