//
//  ClueView.swift
//  GridRace
//
//  Created by Christian on 2/27/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class TextFieldViewController: UIViewController {

    let closure: (String)->()
    let transparentBackgroundView = GradientView()
    let backgroundView = UIView()
    let answerLabel = UILabel()
    let answerTextField = UITextField()
    let submitButton = UIButton()

    init(closure: @escaping (String)->()) {
        self.closure = closure
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = .clear

        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(dismissHandler))
        transparentBackgroundView.addGestureRecognizer(tapGestureRecogniser)

        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.masksToBounds = false
        backgroundView.backgroundColor = AppColors.cellColor

        answerLabel.text = "Enter your answer "
        answerLabel.textAlignment = .center
        answerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        answerLabel.textColor = AppColors.textPrimaryColor

        answerTextField.backgroundColor = AppColors.textPrimaryColor
        answerTextField.layer.cornerRadius = 5
        answerTextField.layer.masksToBounds = false


        let submitButtonAtribs = [ NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24),
                                   NSAttributedStringKey.foregroundColor: AppColors.greenHighlightColor] as [NSAttributedStringKey : Any]
        let submitTitle = NSAttributedString(string: "Submit", attributes: submitButtonAtribs)
        submitButton.setAttributedTitle(submitTitle, for: .normal)
        submitButton.addTarget(self, action: #selector(submitClicked), for: .touchUpInside)


        for view in [transparentBackgroundView, backgroundView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        for view in [answerLabel, answerTextField, submitButton] {
            view.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.addSubview(view)
        }

        NSLayoutConstraint.activate([

            transparentBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            transparentBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transparentBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transparentBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.center.y/4) ),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8 ),
            backgroundView.heightAnchor.constraint(equalToConstant: 160 ),

            answerLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            answerLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),

            answerTextField.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 10),
            answerTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            answerTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            answerTextField.heightAnchor.constraint(equalToConstant: 36),

            submitButton.topAnchor.constraint(greaterThanOrEqualTo: answerLabel.bottomAnchor, constant: 10),
            submitButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            submitButton.bottomAnchor.constraint(greaterThanOrEqualTo: backgroundView.bottomAnchor, constant: -10)
        ])
    }

    @objc func dismissHandler(_ sender: UITapGestureRecognizer) {

        dismiss(animated: true, completion: nil)
    }

    @objc func submitClicked() {
        if !(answerTextField.text?.isEmpty)! {
            closure(answerTextField.text!)
        }
        dismiss(animated: true, completion: nil)
    }



}
