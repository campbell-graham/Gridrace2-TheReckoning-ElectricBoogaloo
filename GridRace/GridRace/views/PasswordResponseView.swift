//
//  PasswordView().swift
//  GridRace
//
//  Created by Christian on 3/6/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class PasswordResponseView: UIView {

    private let passcode = "1234"
    private var attempt = ""
    var textField = UITextField()
    weak var delegate: PasswordResponseViewDelegate?

    private var buttons = [UIButton]()

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
        textField.addTarget(self, action: #selector(thing), for: .editingChanged)
        
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
    
    @objc func thing(_ sender: UITextField) {
        
        let attempt = String(describing: sender.text!)
        print(attempt)
        if attempt.count == passcode.count {
            if attempt == passcode {
                delegate?.presentSummaryScreen()
            } else {
                transform = CGAffineTransform(translationX: 6, y: 0)
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform.identity
                }, completion: nil)
                textField.text = ""
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PasswordResponseViewDelegate : class {
   func presentSummaryScreen()
}
