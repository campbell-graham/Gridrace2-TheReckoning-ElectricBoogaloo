//
//  PasswordView().swift
//  GridRace
//
//  Created by Christian on 3/6/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    private let passcode = "1234"
    private var attempt = ""
    var textField = UITextField()

    private var buttons = [UIButton]()

    init() {
        super.init(nibName: nil, bundle: nil)
        
        //text field set up
        textField.keyboardType = .numberPad
        textField.backgroundColor = AppColors.textPrimaryColor
        textField.textColor = UIColor.black
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
        
        //add items to view
        view.addSubview(textField)
        
    }
    
    override func viewWillLayoutSubviews() {
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        //layout constraints
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.7),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            textField.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


//    @objc func buttonTouched(_ sender: UIButton) {
//
//        attempt += "\(sender.tag)"
//
//        if attempt.count > 4{
//
//            attempt = "\(sender.tag)"
//        } else if attempt.count == 4 {
//
//            if attempt == passcode {
//
//                present(UINavigationController(rootViewController: SummaryViewController()), animated: true, completion: nil)
//            } else {
//                
//                attempt = "wrong"
//            }
//
//        } 
//
//        if buttonCompletion != nil {
//            buttonCompletion!(attempt)
//        }
//
//    }

}
