//
//  summaryViewController.swift
//  GridRace
//
//  Created by Christian on 3/7/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ObjectiveSummaryCollectionViewCellDelegate {
   
    let mainStatView = SummaryStatView()
    let bonusStatView = SummaryStatView()
    let timeStatView = SummaryStatView()
    let pointsStatView = SummaryStatView()

    let finishTime = AppResources.timeToDisplay
    let objectCount = 10
    var isCorrect = true

    lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    // all places and bonus objectives minus 'last'/ 'password' objective
    var allObjectives: [Objective] = Array(AppResources.ObjectiveData.sharedObjectives.objectives.dropLast())
    
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
        for obj in allObjectives {
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
        //to be implemented
    }

    func setUpLayout() {
        
        //add items to view
        view.addSubview(collectionView)
        view.addSubview(mainStatView)
        view.addSubview(bonusStatView)
        view.addSubview(timeStatView)
        view.addSubview(pointsStatView)
        
        //layout constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        mainStatView.translatesAutoresizingMaskIntoConstraints = false
        bonusStatView.translatesAutoresizingMaskIntoConstraints = false
        timeStatView.translatesAutoresizingMaskIntoConstraints = false
        pointsStatView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            //main stat view
            mainStatView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            mainStatView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            mainStatView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -6),
        
            //bonus stat view
            bonusStatView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            bonusStatView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 6),
            bonusStatView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            //time stat view
            timeStatView.topAnchor.constraint(equalTo: mainStatView.bottomAnchor, constant: 12),
            timeStatView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            timeStatView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -6),
            
            //points stat view
            pointsStatView.topAnchor.constraint(equalTo: bonusStatView.bottomAnchor, constant: 12),
            pointsStatView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 6),
            pointsStatView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            //collection view
            collectionView.topAnchor.constraint(equalTo: timeStatView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    
    }
    
    override func viewDidLayoutSubviews() {
        if !(collectionView.collectionViewLayout is CustomFlowLayout) {
            collectionView.collectionViewLayout = CustomFlowLayout(collectionViewWidth: collectionView.frame.width, collectionViewHeigth: collectionView.frame.height, itemSizePoints: UIScreen.main.bounds.width * 0.8)
        }
    }

    //MARK:- collectionView delegate methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allObjectives.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objective = allObjectives[indexPath.row]
        let userData = allData.first(where: {$0.objectiveID == objective.id})
        
        let cell = collectionView.cellForItem(at: indexPath) as! ObjectiveSummaryCollectionViewCell
        
        guard (userData != nil && (userData?.completed)!) else {
            return
        }
        
        userData!.correct = !(userData!.correct)
        
        if (userData?.correct)! {
            cell.markImageView.image = #imageLiteral(resourceName: "tick").withRenderingMode(.alwaysTemplate)
            cell.markImageView.tintColor = AppColors.greenHighlightColor
        } else {
            cell.markImageView.image = #imageLiteral(resourceName: "cross-1").withRenderingMode(.alwaysTemplate)
            cell.markImageView.tintColor = UIColor.red
        }
        
        updateLabels()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "objectiveCell", for: indexPath) as! ObjectiveSummaryCollectionViewCell
        cell.delegate = self
        let objective = allObjectives[indexPath.row]
        let userData = allData.first(where: {$0.objectiveID == objective.id})

        cell.nameLabel.text = objective.name
        
        if (userData?.completed)! {
            
            if objective.answerType == .photo {
                
                cell.responseImageView.isHidden = false
                cell.responseTextLabel.isHidden = true
                
                if let path =  userData?.imageResponseURL?.path {
                    cell.responseImageView.image = UIImage(contentsOfFile: path)?.resized(withBounds: CGSize(width: 200, height: 200))
                } else {
                    cell.responseImageView.image = #imageLiteral(resourceName: "nothing")
                    cell.responseImageView.tintColor = AppColors.cellColor
                }
                cell.responseImageView.contentMode = .scaleAspectFit
            } else if objective.answerType == .text {
                
                cell.responseTextLabel.isHidden = false
                cell.responseImageView.isHidden = true
                
                cell.responseTextLabel.text = userData?.textResponse
            }
        } else {
            cell.responseImageView.isHidden = true
            cell.responseTextLabel.isHidden = false
            cell.responseTextLabel.text = "No Response Given"
        }

        if (userData?.correct)! {
            cell.markImageView.image = #imageLiteral(resourceName: "tick").withRenderingMode(.alwaysTemplate)
            cell.markImageView.tintColor = AppColors.greenHighlightColor
        } else {
            cell.markImageView.image = #imageLiteral(resourceName: "cross-1").withRenderingMode(.alwaysTemplate)
            cell.markImageView.tintColor = UIColor.red
        }

        return cell
    }
    
    func openLargeImage(image: UIImage) {
        present(EnlargenedImageViewController(image: image), animated: true, completion: nil)
    }
}
