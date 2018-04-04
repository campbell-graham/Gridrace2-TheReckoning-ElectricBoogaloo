//
//  DetailViewController.swift
//  GridRace
//
//  Created by Christian on 2/26/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

//MARK:- Protocols

protocol DetailViewControllerDelegate: class {
    func initiateSave()
}

class DetailViewController: UIViewController, PasswordResponseViewDelegate {
    
    var objective: Objective
    var data: ObjectiveUserData

    var keyboardVisibile = false

    private let panView = UIView()
    private let titleLabel = UILabel()
    private let hintImageView = UIImageView()
    private let completeImageView = UIImageView()
    private let pointLabel = UILabel()
    private let descTextView = UITextView()
    private let responseTitleLabel = UILabel()
    private let answerView: UIView

    private let hintPointDeductionValue = 2
    private let passcode: String = {
        return "1234"
    }()

    var delegate: DetailViewControllerDelegate?

    init(objective: Objective, data: ObjectiveUserData) {

        self.objective = objective
        self.data = data

        switch  objective.answerType {
        case .photo: // imageview
            answerView = ImageResponseView()
        case .text: // textView
            answerView = TextResponseView()
        case .password: // textField
            answerView = PasswordResponseView()
        }

        super.init(nibName: nil, bundle: nil)

    }

    override func viewWillDisappear(_ animated: Bool) {
        if answerView is TextResponseView {
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.removeObserver(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        //Delete: wont be in nav bar
        navigationController?.navigationBar.prefersLargeTitles = false
        title = objective.name
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        setUpLayout()
        initialiseViews()

        //present old data if it exists
        if data.completed {
            loadData()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //set textView to be scrolled to top
        descTextView.setContentOffset(CGPoint.zero, animated: false)

    }

    private func initialiseViews() {

        //Colors
        view.backgroundColor = AppColors.backgroundColor
        panView.backgroundColor = AppColors.textPrimaryColor
        titleLabel.textColor = AppColors.textPrimaryColor
        hintImageView.tintColor = AppColors.orangeHighlightColor
        pointLabel.textColor = AppColors.orangeHighlightColor
        descTextView.textColor = AppColors.textPrimaryColor
        descTextView.backgroundColor = AppColors.backgroundColor
        responseTitleLabel.textColor = AppColors.textPrimaryColor

        //fonts
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        pointLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descTextView.font = UIFont.systemFont(ofSize: 14)
        responseTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)

        // misc stuff
        panView.layer.cornerRadius = 2
        panView.layer.masksToBounds = false
        descTextView.isEditable = false
        hintImageView.contentMode = .scaleAspectFit
        completeImageView.contentMode = .scaleAspectFit
        answerView.isUserInteractionEnabled = true


        // set view data
        titleLabel.text = objective.name
        hintImageView.image = #imageLiteral(resourceName: "hint")
        completeImageView.image = data.completed ? #imageLiteral(resourceName: "correct_selected") : #imageLiteral(resourceName: "correct_unselected")
        descTextView.text = objective.desc
        pointLabel.text = (data.adjustedPoints != nil ? "\(data.adjustedPoints!)" : "\(objective.points)") + " Points"

        responseTitleLabel.text = "Your Response"

        //gesture recognisers
        hintImageView.isUserInteractionEnabled = true
        let hintGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(clueButtonHandler))
        hintImageView.addGestureRecognizer(hintGestureRecogniser)

        switch answerView {
        case is ImageResponseView :

            let interactGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
            answerView.addGestureRecognizer(interactGestureRecogniser)
        case is TextResponseView :

            //assign TextViewDelegate
            guard let answerView = self.answerView as? TextResponseView else { return }
            answerView.textView.delegate = self

            answerView.submitButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)

            // create keyboard state observers/ listeners (to reposition view when keyboard apperas/ disappears)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        case is PasswordResponseView:
            guard let answerView = answerView as? PasswordResponseView else { return }
            
            answerView.delegate = self
            answerView.textField.addTarget(self, action: #selector(checkPasscode), for: .editingChanged)
            
            // create keyboard state observers/ listeners (to reposition view when keyboard apperas/ disappears)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        default:
            break
        }
       
        
    }

    private func setUpLayout() {

        for view in [panView, titleLabel, hintImageView, completeImageView, pointLabel, descTextView, responseTitleLabel, answerView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        var constraints = ([

            panView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            panView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panView.heightAnchor.constraint(equalToConstant: 6),
            panView.widthAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: panView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),

            hintImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            hintImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            hintImageView.widthAnchor.constraint(equalToConstant: 24),
            hintImageView.heightAnchor.constraint(equalTo: hintImageView.widthAnchor),

            completeImageView.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            completeImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            completeImageView.widthAnchor.constraint(equalToConstant: 44),
            completeImageView.heightAnchor.constraint(equalTo: completeImageView.widthAnchor),

            pointLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            pointLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pointLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            pointLabel.heightAnchor.constraint(equalToConstant: 20),

            descTextView.topAnchor.constraint(equalTo: pointLabel.bottomAnchor, constant: 8),
            descTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),

            responseTitleLabel.topAnchor.constraint(equalTo: descTextView.bottomAnchor, constant: 8),
            responseTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            responseTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            responseTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            ])

        switch answerView {
        case is ImageResponseView:
            constraints += [
                answerView.topAnchor.constraint(equalTo: responseTitleLabel.bottomAnchor, constant: 16),
                answerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                answerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                answerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)]
        default:
            constraints += [
                answerView.topAnchor.constraint(equalTo: responseTitleLabel.bottomAnchor),
                answerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                answerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                answerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
        }

        NSLayoutConstraint.activate(constraints)

    }

    // MARK: - KeyboardFunctions

    private var originalViewFrame: CGRect = .zero

    @objc func keyboardWillShow(_ notification: Notification) {
        if originalViewFrame == .zero {
            originalViewFrame = view.frame
        }

        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height


        // Assign new frame to your view
        var newFrame = originalViewFrame
        newFrame.origin.y = originalViewFrame.minY-keyboardHeight
        self.view.frame = newFrame

        if let answerView = answerView as? TextResponseView {
            answerView.submitButton.isHidden = false
        }
        keyboardVisibile = true
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard originalViewFrame != .zero else { return }
        self.view.frame = originalViewFrame

        if let answerView = answerView as? TextResponseView {
            answerView.submitButton.isHidden = true
        }
        keyboardVisibile = false
    }

    @objc func dismissKeyboard() {

        if keyboardVisibile, let answerView = answerView as? TextResponseView {

            answerView.textView.resignFirstResponder()
        }
    }


    // MARK: - Private Functions

    @objc func clearTextView() {

        if let answerView = answerView as? TextResponseView {

            answerView.textView.text = ""
            data.textResponse = nil
            completeImageView.image = #imageLiteral(resourceName: "correct_unselected")
            delegate?.initiateSave()
        }
    }

    @objc private func clueButtonHandler() {

        if data.adjustedPoints == nil {
            presentPointLossAlert()
        } else {
            presentClueViewController()
        }
    }

    @objc private func presentPointLossAlert() {

        let alert = UIAlertController(title: "Warning:", message: "The amount of points gained for this objective will be reduced by \(hintPointDeductionValue)", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: { _ in

            self.data.adjustedPoints = self.objective.points - self.hintPointDeductionValue
            self.pointLabel.text = "\(self.data.adjustedPoints!) Points"
            self.delegate?.initiateSave()

            self.presentClueViewController()
        })
        alert.addAction(continueAction)

        present(alert, animated: true, completion: nil)
    }

    private func presentClueViewController() {

        let clueViewController = UINavigationController(rootViewController: EnlargenedImageViewController(hintText: objective.hintText, hintImageURL: data.hintImageURL))
        present(clueViewController, animated: true, completion: nil)
    }
    
    func presentSummaryScreen() {
        present(UINavigationController(rootViewController: SummaryViewController()), animated: true, completion: nil)
    }


    private func loadData() {
        switch objective.answerType {
        case .text:
            if (data.textResponse != nil) {
                (answerView as! TextResponseView).textView.text = data.textResponse
            }
        case .photo:
            if let answerView = answerView as? ImageResponseView, let imageURL = data.imageResponseURL {

                if let image = UIImage(contentsOfFile: imageURL.path) {
                    answerView.setImage(image: image)
                }
            }
        default:
            break
        }
    }
    
    @objc func checkPasscode(_ sender: UITextField) {
        
        guard let answerView = answerView as? PasswordResponseView else { return }
        let attempt = String(describing: sender.text!)
        print(attempt)
        if attempt.count == passcode.count {
            if attempt == passcode {
                answerView.textField.resignFirstResponder()
                presentSummaryScreen()
            } else {
                answerView.transform = CGAffineTransform(translationX: 6, y: 0)
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    answerView.transform = CGAffineTransform.identity
                }, completion: nil)
                answerView.textField.text = ""
            }
        }
    }

}

extension DetailViewController:
UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc private func selectPhoto() {
        
        guard let answerView = answerView as? ImageResponseView else { return }
        
        func takeNewPhoto() {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
        
        if let image = answerView.responseImageView.image {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let actionView = UIAlertAction(title: "View Photo", style: .default, handler: {_ in
                self.present(UINavigationController(rootViewController: EnlargenedImageViewController(image: image)), animated: true, completion: nil)
            })
            let actionTakePhoto = UIAlertAction(title: "Take New Photo", style: .default, handler: {_ in
                takeNewPhoto()
            })
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(actionView)
            alert.addAction(actionTakePhoto)
            alert.addAction(actionCancel)
            present(alert, animated: true, completion: nil)
        } else {
            takeNewPhoto()
        }
    }
    
    func saveImage(image: UIImage) {
        
        let imageData = UIImageJPEGRepresentation(image, 1)
        let imageFilePath = AppResources.documentsDirectory().appendingPathComponent("Photo_\(objective.id).jpeg")
        do {
            try imageData?.write(to: imageFilePath)
            data.imageResponseURL = imageFilePath
            delegate?.initiateSave()
        } catch {
            print("Failed to save image")
        }
    }

    // MARK:- Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = (info[UIImagePickerControllerOriginalImage] as? UIImage)?.resized(withBounds: UIScreen.main.bounds.size) {
            saveImage(image: image)
            if let answerView = answerView as? ImageResponseView {
                answerView.setImage(image: image)
                completeImageView.image = #imageLiteral(resourceName: "correct_selected")
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UITextViewDelegate {

    func textViewDidEndEditing(_ textView: UITextView) {
        if let answerView = answerView as? TextResponseView {

            data.textResponse = answerView.textView.text
            completeImageView.image = #imageLiteral(resourceName: "correct_selected")
            delegate?.initiateSave()
        }
    }

}
