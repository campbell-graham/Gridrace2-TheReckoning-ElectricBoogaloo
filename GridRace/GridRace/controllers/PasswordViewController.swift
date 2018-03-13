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
    var buttonCompletion: ( (_ attempt: String)->() )?

    private var buttons = [UIButton]()

    override func viewDidLoad() {

        for index in 1...9 {

            let button = UIButton()

            button.setTitle("\(index)", for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
            button.showsTouchWhenHighlighted = true
            buttons.append(button)

            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
        }
    }

    func activateButtonConstraints() {


        let buttonHeight = view.frame.width * 0.16

        NSLayoutConstraint.activate([

            buttons[0].centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.1666),
            buttons[0].centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1666),
            buttons[0].widthAnchor.constraint(equalToConstant: buttonHeight),
            buttons[0].heightAnchor.constraint(equalTo: buttons[0].widthAnchor),

            buttons[1].centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.5),
            buttons[1].centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1666),
            buttons[1].widthAnchor.constraint(equalTo: buttons[0].widthAnchor),
            buttons[1].heightAnchor.constraint(equalTo: buttons[0].widthAnchor),

            buttons[2].centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.8333),
            buttons[2].centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1666),
            buttons[2].widthAnchor.constraint(equalTo: buttons[0].widthAnchor),
            buttons[2].heightAnchor.constraint(equalTo: buttons[0].widthAnchor),

            buttons[3].centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.1666),
            buttons[3].centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.5),
            buttons[3].widthAnchor.constraint(equalTo: buttons[0].widthAnchor),
            buttons[3].heightAnchor.constraint(equalTo: buttons[0].widthAnchor),

            buttons[4].centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.5),
            buttons[4].centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.5),
            buttons[4].widthAnchor.constraint(equalTo: buttons[0].widthAnchor),
            buttons[4].heightAnchor.constraint(equalTo: buttons[0].widthAnchor),

            buttons[5].centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.8333),
            buttons[5].centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.5),
            buttons[5].widthAnchor.constraint(equalTo: buttons[0].widthAnchor),
            buttons[5].heightAnchor.constraint(equalTo: buttons[0].widthAnchor),

            buttons[6].centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.1666),
            buttons[6].centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.8333),
            buttons[6].widthAnchor.constraint(equalTo: buttons[0].widthAnchor),
            buttons[6].heightAnchor.constraint(equalTo: buttons[0].widthAnchor),

            buttons[7].centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.5),
            buttons[7].centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.8333),
            buttons[7].widthAnchor.constraint(equalTo: buttons[0].widthAnchor),
            buttons[7].heightAnchor.constraint(equalTo: buttons[0].widthAnchor),

            buttons[8].centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.8333),
            buttons[8].centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.8333),
            buttons[8].widthAnchor.constraint(equalTo: buttons[0].widthAnchor),
            buttons[8].heightAnchor.constraint(equalTo: buttons[0].widthAnchor),

            ])

        setCornerRadius(height: buttonHeight)
    }

    func setCornerRadius(height: CGFloat) {
        for b in buttons {
            b.clipsToBounds = true
            b.layer.borderColor = #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2705882353, alpha: 1).cgColor
            b.layer.borderWidth = 3
            b.layer.cornerRadius = (height / 2)
            b.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2705882353, alpha: 1).withAlphaComponent(0.5)
        }
    }

    @objc func buttonTouched(_ sender: UIButton) {

        attempt += "\(sender.tag)"

        if attempt.count > 4{

            attempt = "\(sender.tag)"
        } else if attempt.count == 4 {

            if attempt == passcode {

                present(UINavigationController(rootViewController: SummaryViewController()), animated: true, completion: nil)
            } else {
                
                attempt = "wrong"
            }

        } 

        if buttonCompletion != nil {
            buttonCompletion!(attempt)
        }

    }

}
