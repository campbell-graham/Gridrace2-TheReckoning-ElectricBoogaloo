//
//  DetailViewController.swift
//  GridRace
//
//  Created by Christian on 2/26/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import RSKImageCropper

class DetailViewController: UIViewController {

    var objective: Objective
    var data: ObjectiveUserData

    let panView = PanView()

    private let titleLabel = UILabel()
    private let descTextView = UITextView()
    private let pointLabel = UILabel()
    private let responseTextLabel = UILabel()
    private let answerView: UIView
    private let hintImageView = UIImageView()
    private let hintPointDeductionValue = 2
    private var passwordViewController: PasswordViewController?
    
    var delegate: ObjectiveTableViewControllerDelegate?
    

    init(objective: Objective, data: ObjectiveUserData) {

        self.objective = objective
        self.data = data

        switch  objective.answerType {
        case .photo: // imageview
            answerView = ImageResponseView()
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
        self.descTextView.text = "\(objective.desc) \n attempt: \(attempt) "
    }


    override func viewDidLoad() {

        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
        title = objective.name

        setUpLayout()
        initialiseViews()
    
        //present old data if it exists
        if data.completed {
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

    private func initialiseViews() {

        //Colors
        view.backgroundColor = AppColors.backgroundColor
        titleLabel.textColor = AppColors.textPrimaryColor
        hintImageView.tintColor = AppColors.greenHighlightColor
        pointLabel.textColor = AppColors.greenHighlightColor
        descTextView.textColor = AppColors.textPrimaryColor
        descTextView.backgroundColor = AppColors.backgroundColor
        responseTextLabel.textColor = AppColors.textPrimaryColor

        updateViewsData()

        // misc stuff
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)

        pointLabel.font = UIFont.boldSystemFont(ofSize: 16)

        descTextView.font = UIFont.systemFont(ofSize: 14)
        descTextView.isEditable = false

        responseTextLabel.font = UIFont.boldSystemFont(ofSize: 20)

        let interactGestureRecogniser: UITapGestureRecognizer
        switch answerView {
        case is ImageResponseView :
            interactGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        case is TextResponseView :
            interactGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(enterAnswer))
        default:
            interactGestureRecogniser = UITapGestureRecognizer(target: self, action: nil)
        }

        answerView.addGestureRecognizer(interactGestureRecogniser)
        answerView.isUserInteractionEnabled = true

        let hintGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(clueButtonHandler))
        hintImageView.addGestureRecognizer(hintGestureRecogniser)
        hintImageView.isUserInteractionEnabled = true
        hintImageView.contentMode = .scaleAspectFit
    }

    private func updateViewsData() {

        titleLabel.text = "Overview"
        hintImageView.image = #imageLiteral(resourceName: "hint")
        if objective.answerType == .password {
            descTextView.text = "\(objective.desc) \n attempt: "
        } else {
            descTextView.text = objective.desc
        }
        pointLabel.text = (data.adjustedPoints != nil ? "\(data.adjustedPoints!)" : "\(objective.points)") + " Points"

        responseTextLabel.text = "Your Response"

    }

    private func setUpLayout() {

        for view in [panView, titleLabel, hintImageView, pointLabel, descTextView, responseTextLabel, answerView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        var constraints = ([

            panView.topAnchor.constraint(equalTo: view.topAnchor),
            panView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            panView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            panView.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: panView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),

            hintImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            hintImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            hintImageView.widthAnchor.constraint(equalToConstant: 32),
            hintImageView.heightAnchor.constraint(equalTo: hintImageView.widthAnchor),

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
            answerView.textView.text = answer
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
        descTextView.setContentOffset(CGPoint.zero, animated: false)

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
        present(imagePicker, animated: true, completion: nil)
    }

    private func choosePhotoFromLibrary() {

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
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

    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        // crop and resize chosen image (for optimial space, as we are storing image data in core data)

        let resizedImage = croppedImage.resized(withBounds:  CGSize(width: answerView.frame.width, height: answerView.frame.height))
        if let answerView = answerView as? ImageResponseView {

            answerView.setImage(image: resizedImage)
        }
        dismiss(animated: true, completion: nil)

        //save image
        let imageData = UIImageJPEGRepresentation(resizedImage, 1)
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
