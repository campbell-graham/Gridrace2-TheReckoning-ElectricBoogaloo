//
//  PasswordView().swift
//  GridRace
//
//  Created by Christian on 3/6/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class PasswordResponseView: UIView {

    var textField = UITextField()
    weak var delegate: PasswordResponseViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //text field set up
        textField.keyboardType = .numberPad
        textField.backgroundColor = AppColors.textPrimaryColor
        textField.isSecureTextEntry = true
        textField.placeholder = "Enter Passcode"
        textField.textColor = UIColor.black
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
        
        //add items to view
        addSubview(textField)
        
        //layout constraints
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            textField.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PasswordResponseViewDelegate : class {
   func presentSummaryScreen()
}
