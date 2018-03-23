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
    let deleteButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        textView.backgroundColor = AppColors.textPrimaryColor
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.layer.cornerRadius = 16
        textView.layer.masksToBounds = false
        textView.textContainerInset = .init(top: 32, left: 32, bottom: 32, right: 32)

        deleteButton.setImage(#imageLiteral(resourceName: "cross-1"), for: .normal)

        for view in [ textView, deleteButton] as [UIView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),

            deleteButton.topAnchor.constraint(equalTo: textView.topAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(greaterThanOrEqualTo: textView.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -16),
            deleteButton.heightAnchor.constraint(equalToConstant: 24),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
        ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
