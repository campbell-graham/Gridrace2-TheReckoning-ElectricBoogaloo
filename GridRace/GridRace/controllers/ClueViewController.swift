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

    init(objective: Objective) {

        clueImageView.image = objective.imageURL != nil ? #imageLiteral(resourceName: "eye") : #imageLiteral(resourceName: "eye") 
        clueLabel.text = objective.hintText
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

        clueImageView.contentMode = .scaleAspectFit

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

            clueBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clueBackgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),            
            clueBackgroundView.widthAnchor.constraint(equalToConstant: (view.frame.size.width/4 * 3) ),
            clueBackgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: view.frame.size.height/2),

            clueImageView.topAnchor.constraint(equalTo: clueBackgroundView.topAnchor, constant: 20),
            clueImageView.centerXAnchor.constraint(equalTo: clueBackgroundView.centerXAnchor),
            clueImageView.heightAnchor.constraint(equalToConstant: 200),
            clueImageView.widthAnchor.constraint(equalToConstant: 200),

            clueLabel.topAnchor.constraint(equalTo: clueImageView.bottomAnchor, constant: 20),
            clueLabel.leadingAnchor.constraint(equalTo: clueBackgroundView.leadingAnchor, constant: 10),
            clueLabel.trailingAnchor.constraint(equalTo: clueBackgroundView.trailingAnchor, constant: -10),
            clueLabel.bottomAnchor.constraint(equalTo: clueBackgroundView.bottomAnchor, constant: -20)
        ])
    }

    @objc func dismiss(_ sender: UITapGestureRecognizer) {

        dismiss(animated: true, completion: nil)
    }



}
