//
//  textFieldView.swift
//  GridRace
//
//  Created by Christian on 2/28/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class TextResponseView: UIView {

    let textView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        textView.backgroundColor = AppColors.textPrimaryColor
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.layer.cornerRadius = 16
        textView.layer.masksToBounds = false
        textView.textContainerInset = .init(top: 32, left: 32, bottom: 32, right: 32)

        textView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
