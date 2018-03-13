//
//  DetailViewController.swift
//  GridRace
//
//  Created by Christian on 2/26/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var objective: Objective
    var data: ObjectiveUserData
    let panView = PanView()
    private let descLabel = UITextView()
    let pointBorderImageView = UIImageView()
    private let pointLabel = UILabel()
    private let answerView: UIView
    private let interactImageView = UIImageView()
    private let hintImageView = UIImageView()
    private let hintPointDeductionValue = 2
    private var passwordViewController: PasswordViewController?
    
    var delegate: ObjectiveTableViewControllerDelegate?
    

    init(objective: Objective, data: ObjectiveUserData) {

        self.objective = objective
        self.data = data

        switch  objective.answerType {
        case .photo: // imageview
            answerView = UIImageView()
        case .text: // textField
            answerView = TextResponseView()
        case .password: // pin view

            passwordViewController = PasswordViewController()
            answerView = passwordViewController!.view
        }

        super.init(nibName: nil, bundle: nil)

        defer {
            if passwordViewController != nil {
                addChildViewController(passwordViewController!)
                passwordViewController!.didMove(toParentViewController: self)
                passwordViewController?.buttonCompletion = self.updateLabel
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateLabel(attempt: String) {
        self.descLabel.text = "\(objective.desc) \n attempt: \(attempt) "
    }


    override func viewDidLoad() {

        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
        title = objective.name

        initialiseViews()
        setUpLayout()
    
        //present old data if it exists
        if data.completed {
            switch objective.answerType {
            case .text:
                if (data.textResponse != nil) {
                    (answerView as! TextResponseView).textLabel.text = data.textResponse
                }
            case .password:
                print("Not implemented yet")
            case .photo:
                if let answerView = answerView as? UIImageView, let imageURL = data.imageResponseURL {
                    answerView.contentMode = .scaleAspectFit
                    answerView.image = UIImage(contentsOfFile: imageURL.path)?.resized(withBounds:  CGSize(width: 200, height: 200))
                }
            }
        }
    }

    private func initialiseViews() {

        //Colors
        view.backgroundColor = AppColors.backgroundColor
        descLabel.textColor = AppColors.textPrimaryColor
        pointLabel.textColor = AppColors.greenHighlightColor
        pointBorderImageView.tintColor = AppColors.greenHighlightColor
        interactImageView.tintColor = AppColors.greenHighlightColor
        hintImageView.tintColor = AppColors.greenHighlightColor

        updateViewsData()

        // misc stuff
        descLabel.backgroundColor = AppColors.backgroundColor
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.isEditable = false

        pointBorderImageView.isUserInteractionEnabled = true
        pointBorderImageView.contentMode = .scaleAspectFit

        pointLabel.font = UIFont.boldSystemFont(ofSize: 16)

        let interactGestureRecogniser: UITapGestureRecognizer

        switch answerView {
        case is UIImageView :
            interactGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        case is TextResponseView :
            interactGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(enterAnswer))
        default:
            interactGestureRecogniser = UITapGestureRecognizer(target: self, action: nil)
        }

        interactImageView.addGestureRecognizer(interactGestureRecogniser)
        interactImageView.isUserInteractionEnabled = true
        interactImageView.contentMode = .scaleAspectFit

        let hintGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(clueButtonHandler))
        hintImageView.addGestureRecognizer(hintGestureRecogniser)
        hintImageView.isUserInteractionEnabled = true
        hintImageView.contentMode = .scaleAspectFit
    }

    private func updateViewsData() {

        if objective.answerType == .password {
            descLabel.text = "\(objective.desc) \n attempt: "
        } else {
            descLabel.text = objective.desc
        }
        pointBorderImageView.image = #imageLiteral(resourceName: "circle")
        pointLabel.text = data.adjustedPoints != nil ? "\(data.adjustedPoints!)" : "\(objective.points)"
        hintImageView.image = #imageLiteral(resourceName: "hint")

        switch  answerView {
        case is UIImageView:
            interactImageView.image = #imageLiteral(resourceName: "camera")
        case is TextResponseView:
            interactImageView.image = #imageLiteral(resourceName: "textCursor")
        default:
            interactImageView.image = #imageLiteral(resourceName: "flag")
        }
    }

    private func setUpLayout() {

        for view in [panView, descLabel, pointBorderImageView, answerView, interactImageView, hintImageView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        pointLabel.translatesAutoresizingMaskIntoConstraints = false
        pointBorderImageView.addSubview(pointLabel)

        var constraints = ([

            panView.topAnchor.constraint(equalTo: view.topAnchor),
            panView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            panView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            panView.heightAnchor.constraint(equalToConstant: 30),

            descLabel.topAnchor.constraint(equalTo: panView.bottomAnchor, constant: 16),
            descLabel.leadingAnchor.constraint(equalTo: pointBorderImageView.trailingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),

            pointBorderImageView.topAnchor.constraint(equalTo: descLabel.topAnchor),
            pointBorderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pointBorderImageView.heightAnchor.constraint(equalToConstant: 64),
            pointBorderImageView.widthAnchor.constraint(equalToConstant: 64),

            pointLabel.centerXAnchor.constraint(equalTo: pointBorderImageView.centerXAnchor),
            pointLabel.centerYAnchor.constraint(equalTo: pointBorderImageView.centerYAnchor),
        ])

        switch answerView {
        case is UIImageView:
            constraints += [
                answerView.topAnchor.constraint(greaterThanOrEqualTo: descLabel.bottomAnchor, constant: 16),
                answerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                answerView.bottomAnchor.constraint(lessThanOrEqualTo: interactImageView.topAnchor, constant: -16),
                answerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
                answerView.heightAnchor.constraint(equalTo: answerView.widthAnchor),

                interactImageView.topAnchor.constraint(greaterThanOrEqualTo: answerView.bottomAnchor, constant: 16),]
        case is TextResponseView:
            constraints += [
                answerView.topAnchor.constraint(equalTo: descLabel.bottomAnchor),
                answerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                answerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                answerView.bottomAnchor.constraint(equalTo: interactImageView.topAnchor)]
        default:
            constraints += [
                answerView.topAnchor.constraint(equalTo: descLabel.bottomAnchor),
                answerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                answerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                answerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        }

        if objective.answerType != .password {
            constraints += [

                interactImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(view.center.x / 2) ),
                interactImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
                interactImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
                interactImageView.heightAnchor.constraint(equalTo: interactImageView.widthAnchor),

                hintImageView.topAnchor.constraint(equalTo: interactImageView.topAnchor),
                hintImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: (view.center.x / 2) ),
                hintImageView.bottomAnchor.constraint(equalTo: interactImageView.bottomAnchor),
                hintImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
                hintImageView.heightAnchor.constraint(equalTo: hintImageView.widthAnchor)
            ]
        } else {

            interactImageView.isHidden = true
            hintImageView.isHidden = true
        }

        NSLayoutConstraint.activate(constraints)

    }

    @objc private func clueButtonHandler() {
        
        guard let points = data.adjustedPoints else {
            presentPointLossAlert()
            return
        }
            presentClueViewController()
    }

    @objc private func presentPointLossAlert() {

        let alert = UIAlertController(title: "Warning:", message: "The amount of points gained for this objective will be reduced by \(hintPointDeductionValue)", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: { _ in
            self.data.adjustedPoints = self.objective.points - self.hintPointDeductionValue
            //self.objective.hintTaken = true
            self.updateViewsData()
            self.presentClueViewController()
            self.delegate?.initiateSave()
        })
        alert.addAction(continueAction)

        present(alert, animated: true, completion: nil)
    }

    private func presentClueViewController() {
        let clueViewController = ClueViewController(objective: objective)
        clueViewController.modalTransitionStyle = .crossDissolve
        clueViewController.modalPresentationStyle = .overCurrentContext
        present(clueViewController, animated: true, completion: nil)
    }

    @objc func enterAnswer() {

        let textFieldViewController = TextFieldViewController(closure: enterAnswerCompletion)
        textFieldViewController.modalTransitionStyle = .crossDissolve
        textFieldViewController.modalPresentationStyle = .overCurrentContext
        present(textFieldViewController, animated: true, completion: nil)
    }

    func enterAnswerCompletion(answer: String) {

        if let answerView = answerView as? TextResponseView {
            answerView.textLabel.text = answer
            playHudAnimation()
            data.textResponse = answer
            delegate?.initiateSave()
        }
    }

    private func playHudAnimation() {

        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        hudView.text = "Complete!"

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0,
          execute: {
            hudView.hide()
            //self.navigationController?.popViewController(animated: true)
        })
    }

    //set textView to be scrolled to top
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descLabel.setContentOffset(CGPoint.zero, animated: false)

        if let VC = childViewControllers.last as? PasswordViewController {

            VC.activateButtonConstraints()
        }

    }
    
}

extension DetailViewController:
UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc private func selectPhoto() {

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            takePhotoWithCamera()
        } else {
            choosePhotoFromLibrary()
        }
    }

    private func takePhotoWithCamera() {

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    private func choosePhotoFromLibrary() {

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }



    // MARK:- Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let retrivedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        if let answerView = answerView as? UIImageView {
            answerView.contentMode = .scaleAspectFit
            answerView.image = retrivedImage?.resized(withBounds:  CGSize(width: 200, height: 200))
        }
        dismiss(animated: true, completion: nil)
        
        //save image
        let imageData = UIImageJPEGRepresentation(retrivedImage!, 1)
        let imageFilePath = AppResources.documentsDirectory().appendingPathComponent("Photo_\(objective.id).jpeg")
        do {
            try imageData?.write(to: imageFilePath)
            data.imageResponseURL = imageFilePath
        } catch {
            print("Failed to save image")
        }

        playHudAnimation()
        delegate?.initiateSave()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }
    
}
