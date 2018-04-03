//
//  textFieldView.swift
//  GridRace
//
//  Created by Christian on 2/28/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class TextResponseView: UIView {

    let backgroundView = UIView()
    let textView = UITextView()
    let submitButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundView.backgroundColor = AppColors.textPrimaryColor
        backgroundView.layer.cornerRadius = 16
        backgroundView.layer.masksToBounds = false

        textView.backgroundColor = AppColors.textPrimaryColor
        textView.font = UIFont.systemFont(ofSize: 14)

        let atribs: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),
                                                     NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.0431372549, green: 0.1137254902, blue: 0.1921568627, alpha: 1) ]
        let atribString = NSAttributedString(string: "Submit", attributes: atribs)
        submitButton.setAttributedTitle(atribString, for: .normal)
        submitButton.isHidden = true

        for view in [ backgroundView, textView, submitButton] as [UIView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        NSLayoutConstraint.activate([

            backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),

            textView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -60),

            submitButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            submitButton.leadingAnchor.constraint(greaterThanOrEqualTo: textView.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -8),
            submitButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16)
        ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
