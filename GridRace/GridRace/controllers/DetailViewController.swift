//
//  DetailViewController.swift
//  GridRace
//
//  Created by Christian on 2/26/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import RSKImageCropper

//MARK:- Protocols

protocol DetailViewControllerDelegate: class {
    func initiateSave()
}

class DetailViewController: UIViewController {

    var objective: Objective
    var data: ObjectiveUserData

    var keyboardVisibile = false

    private let panView = UIView()
    private let titleLabel = UILabel()
    private let hintImageView = UIImageView()
    private let completeImageView = UIImageView()
    private let pointLabel = UILabel()
    private let descTextView = UITextView()
    private let responseTextLabel = UILabel()
    private let answerView: UIView

    //Delete: rethink storing this value here, can we put it in firebase?
    private let hintPointDeductionValue = 2

    private var passwordViewController: PasswordViewController?

    var delegate: DetailViewControllerDelegate?

    init(objective: Objective, data: ObjectiveUserData) {

        self.objective = objective
        self.data = data

        switch  objective.answerType {
        case .photo: // imageview
            answerView = ImageResponseView()
        case .text: // textField
            self.answerView = TextResponseView()
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

    //Delete: rethink password implimentstion
    func updateLabel(attempt: String) {
        self.descTextView.text = "\(objective.desc) \n attempt: \(attempt) "
    }

    deinit {

        // remove keyboard will show & will hide observers
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

        //Delete: this seems dodgy (make password view controller seperate and only call at end? dont tie it to objectives?)
        if let VC = childViewControllers.last as? PasswordViewController {

            VC.activateButtonConstraints()
        }
    }

    private func initialiseViews() {

        //Colors
        view.backgroundColor = AppColors.backgroundColor
        panView.backgroundColor = AppColors.textPrimaryColor
        titleLabel.textColor = AppColors.textPrimaryColor
        hintImageView.tintColor = AppColors.orangeHighlightColor
        completeImageView.tintColor = data.completed ? AppColors.greenHighlightColor : AppColors.textSecondaryColor
        pointLabel.textColor = AppColors.orangeHighlightColor
        descTextView.textColor = AppColors.textPrimaryColor
        descTextView.backgroundColor = AppColors.backgroundColor
        responseTextLabel.textColor = AppColors.textPrimaryColor

        //fonts
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        pointLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descTextView.font = UIFont.systemFont(ofSize: 14)
        responseTextLabel.font = UIFont.boldSystemFont(ofSize: 20)

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
        completeImageView.image = #imageLiteral(resourceName: "tick")
        if objective.answerType == .password {
            descTextView.text = "\(objective.desc) \n attempt: "
        } else {
            descTextView.text = objective.desc
        }
        pointLabel.text = (data.adjustedPoints != nil ? "\(data.adjustedPoints!)" : "\(objective.points)") + " Points"

        responseTextLabel.text = "Your Response"

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
            let answerView = self.answerView as! TextResponseView
            answerView.textView.delegate = self

            answerView.submitButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)

            // create keyboard state observers/ listeners (to reposition view when keyboard apperas/ disappears)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        default:
            break
        }
    }

    private func setUpLayout() {

        for view in [panView, titleLabel, hintImageView, completeImageView, pointLabel, descTextView, responseTextLabel, answerView] {
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

            responseTextLabel.topAnchor.constraint(equalTo: descTextView.bottomAnchor, constant: 8),
            responseTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            responseTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            responseTextLabel.heightAnchor.constraint(equalToConstant: 20),
            ])

        switch answerView {
        case is ImageResponseView:
            constraints += [
                answerView.topAnchor.constraint(equalTo: responseTextLabel.bottomAnchor, constant: 16),
                answerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                answerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                answerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)]
        case is TextResponseView:
            constraints += [
                answerView.topAnchor.constraint(equalTo: responseTextLabel.bottomAnchor),
                answerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                answerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                answerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ]
        default:
            constraints += [
                answerView.topAnchor.constraint(equalTo: responseTextLabel.bottomAnchor),
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

        keyboardVisibile = true
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard originalViewFrame != .zero else { return }
        self.view.frame = originalViewFrame
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
            completeImageView.tintColor = AppColors.textSecondaryColor
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
        let clueViewController = ClueViewController(objective: objective)
        clueViewController.modalTransitionStyle = .crossDissolve
        clueViewController.modalPresentationStyle = .overCurrentContext
        present(clueViewController, animated: true, completion: nil)
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

}

extension DetailViewController:
UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc private func selectPhoto() {

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK:- Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            let imageCropperViewController = RSKImageCropViewController(image: image)

            imageCropperViewController.cropMode = RSKImageCropMode.custom
            imageCropperViewController.delegate = self
            imageCropperViewController.dataSource = self
            imageCropperViewController.alwaysBounceVertical = true
            imageCropperViewController.avoidEmptySpaceAroundImage = true
            picker.pushViewController(imageCropperViewController, animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }

}

extension DetailViewController:
RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource {

    func saveImage(image: UIImage) {

        let imageData = UIImageJPEGRepresentation(image, 1)
        let imageFilePath = AppResources.documentsDirectory().appendingPathComponent("Photo_\(objective.id).jpeg")
        do {
            try imageData?.write(to: imageFilePath)
            data.imageResponseURL = imageFilePath
        } catch {
            print("Failed to save image")
        }
    }

    // MARK:- Image Croper Delegates

    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {

        // crop and resize chosen image to size of UIImageView controller
        let resizedImage = croppedImage.resized(withBounds:  CGSize(width: answerView.frame.width, height: answerView.frame.height))
        if let answerView = answerView as? ImageResponseView {
            answerView.setImage(image: resizedImage)
        }
        dismiss(animated: true, completion: nil)

        saveImage(image: resizedImage)

        completeImageView.tintColor = AppColors.greenHighlightColor
        delegate?.initiateSave()
    }

    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return maskRect(controller: controller)
    }

    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        return maskRect(controller: controller)
    }

    func maskRect(controller: RSKImageCropViewController) -> CGRect {
        let maskSize = CGSize(width: view.frame.width, height: answerView.bounds.height)
        let viewHeight = controller.view.frame.height

        // create and return shape for cropping image
        return CGRect(x: 0, y: viewHeight * 0.5 - maskSize.height / 2.0, width: maskSize.width, height: maskSize.height)
    }

    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {

        // return path from mask shape
        return UIBezierPath(rect: controller.maskRect);
    }

    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UITextViewDelegate {

    func textViewDidEndEditing(_ textView: UITextView) {
        if let answerView = answerView as? TextResponseView {

            data.textResponse = answerView.textView.text
            completeImageView.tintColor = AppColors.greenHighlightColor
            delegate?.initiateSave()
        }
    }

}
