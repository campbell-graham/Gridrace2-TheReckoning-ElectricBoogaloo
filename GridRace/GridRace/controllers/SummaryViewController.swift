//
//  summaryViewController.swift
//  GridRace
//
//  Created by Christian on 3/7/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let mainTextLabel = UILabel()
    let mainValueLabel = UILabel()
    let bonusTextLabel = UILabel()
    let bonusValueLabel = UILabel()
    let timeTextLabel = UILabel()
    let timeValueLabel = UILabel()
    let pointsTextLabel = UILabel()
    let pointsValueLabel = UILabel()

    let objectCount = 10
    var isCorrect = true

    lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    // all places and bonus objectives minus 'last'/ 'password' objective
    var allObjectives: [Objective] = AppResources.ObjectiveData.sharedObjectives.objectives
    
    var allData = AppResources.ObjectiveData.sharedObjectives.data
    
    var mainObjectives: [Objective]
    

    var bonusObjectives: [Objective]

    var completedObjectives: Int {

        var result = 0
        for data in allData {
            if data.completed == true {
                result += 1
            }
        }
        return result
    }

    var completedPlacesObjectivesCount: Int {

        var result = 0
        for objective in mainObjectives {
            let data = allData.first(where: {$0.objectiveID == objective.id})
            if data?.completed == true {
                result += 1
            }
        }
        return result
    }

    var completedBonusObjectivesCount: Int {

        var result = 0
        for objective in bonusObjectives {
            let data = allData.first(where: {$0.objectiveID == objective.id})
            if data?.completed == true {
                result += 1
            }
        }
        return result
    }

    var userPoints: Int {

        var result = 0
        for objective in allObjectives {
            let dataForObject = allData.first(where: {$0.objectiveID == objective.id})
            if (dataForObject?.completed)! {
                result += dataForObject?.adjustedPoints != nil ? (dataForObject?.adjustedPoints)! : objective.points
            }
        }

        return result
    }

    var totalPoints: Int {

        var result = 0
        for obj in allObjectives{

            result += obj.points
        }
        return result
    }
    
    init() {
        mainObjectives = allObjectives.filter({$0.objectiveType == .main})
        bonusObjectives = allObjectives.filter({$0.objectiveType == .bonus})
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Summary"
        edgesForExtendedLayout = []
        view.backgroundColor = AppColors.backgroundColor

        setUpLayout()

        updateLabels()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = AppColors.backgroundColor
        collectionView.register(ObjectiveSummaryCollectionViewCell.self, forCellWithReuseIdentifier: "objectiveCell")
    }

    func updateLabels() {

        mainTextLabel.text = "Main Objectives: "
        mainValueLabel.text = "\(completedPlacesObjectivesCount)/\(mainObjectives.count)"
        bonusTextLabel.text = "Bonus Objectives: "
        bonusValueLabel.text = "\(completedBonusObjectivesCount)/\(bonusObjectives.count)"
        timeTextLabel.text = "Time: "
        timeValueLabel.text = "\(AppResources.timeToDisplay)"
        pointsTextLabel.text = "Points: "
        pointsValueLabel.text = "\(userPoints)/\(totalPoints)"
    }

    func setUpLayout() {

        for view in [mainTextLabel, mainValueLabel, bonusTextLabel, bonusValueLabel, timeTextLabel,
                     timeValueLabel, pointsTextLabel, pointsValueLabel] {

            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.textColor = AppColors.textPrimaryColor
        }

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        let views: [String: Any] = [
            "mainTextLabel" : mainTextLabel,
            "mainValueLabel" : mainValueLabel,
            "bonusTextLabel" : bonusTextLabel,
            "bonusValueLabel" : bonusValueLabel,
            "timeTextLabel" : timeTextLabel,
            "timeValueLabel" : timeValueLabel,
            "pointsTextLabel" : pointsTextLabel,
            "pointsValueLabel" : pointsValueLabel
        ]

        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-32-[mainTextLabel]-[bonusTextLabel]-[timeTextLabel]-[pointsTextLabel]", options: [.alignAllLeading], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[mainValueLabel]-[bonusValueLabel]-[timeValueLabel]-[pointsValueLabel]", options: [.alignAllLeading], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[mainTextLabel]-32-[mainValueLabel]", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)


        constraints += [
            
            mainTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
           
            collectionView.topAnchor.constraint(equalTo: pointsTextLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    
    
    override func viewDidLayoutSubviews() {
        if !(collectionView.collectionViewLayout is CustomFlowLayout) {
            collectionView.collectionViewLayout = CustomFlowLayout(collectionViewWidth: collectionView.frame.width, collectionViewHeigth: collectionView.frame.height, itemSizePoints: 250)
        }
    }

    //MARK:- collectionView delegate methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allObjectives.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let data = allData.first(where: {$0.objectiveID == allObjectives[indexPath.row].id})
        data!.correct = !(data!.correct)

        updateLabels()
        
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "objectiveCell", for: indexPath) as! ObjectiveSummaryCollectionViewCell

        let objective = allObjectives[indexPath.row]
        let userData = allData.first(where: {$0.objectiveID == objective.id})

        cell.nameLabel.text = objective.name
        cell.descLabel.text = objective.desc

        if objective.answerType == .photo {

            cell.responseImageView.isHidden = false
            cell.responseTextView.isHidden = true

            if let path =  userData?.imageResponseURL?.path {

                cell.responseImageView.image = UIImage(contentsOfFile: path)?.resized(withBounds: CGSize(width: 200, height: 200))
            } else {

                cell.responseImageView.image = #imageLiteral(resourceName: "nothing")
                cell.responseImageView.tintColor = AppColors.cellColor
            }
            cell.responseImageView.contentMode = .scaleAspectFit
        } else if objective.answerType == .text {

            cell.responseTextView.isHidden = false
            cell.responseImageView.isHidden = true

            cell.responseTextView.text = userData?.textResponse != nil ? userData?.textResponse : "No Response Given"
        }

        if userData!.completed {

            cell.crossImageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.checkMarkImageView.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else {

            cell.crossImageView.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell.checkMarkImageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }

        return cell
    }

}
