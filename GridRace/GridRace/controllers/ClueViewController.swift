//
//  ClueView.swift
//  GridRace
//
//  Created by Christian on 2/27/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class ClueViewController: UIViewController {

    let transparentBackgroundView = GradientView()
    let clueBackgroundView = UIView()
    let clueImageView = UIImageView()
    let clueLabel = UILabel()

    init(hintText: String, hintImageURL: URL? ) {

        clueLabel.text = hintText

        clueImageView.contentMode = .scaleAspectFill
        if hintImageURL != nil, let image = UIImage(contentsOfFile: hintImageURL!.path) {
            clueImageView.image = image
        } else {
            clueImageView.image = #imageLiteral(resourceName: "placeHolder")
        }
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
            clueImageView.bottomAnchor.constraint(equalTo: clueLabel.topAnchor, constant: -16),

            clueLabel.topAnchor.constraint(equalTo: clueLabel.bottomAnchor, constant: -120),
            clueLabel.leadingAnchor.constraint(equalTo: clueBackgroundView.leadingAnchor, constant: 10),
            clueLabel.trailingAnchor.constraint(equalTo: clueBackgroundView.trailingAnchor, constant: -10),
            clueLabel.bottomAnchor.constraint(equalTo: clueBackgroundView.bottomAnchor, constant: -20)
        ])
    }

    @objc func dismiss(_ sender: UITapGestureRecognizer) {

        dismiss(animated: true, completion: nil)
    }



}
