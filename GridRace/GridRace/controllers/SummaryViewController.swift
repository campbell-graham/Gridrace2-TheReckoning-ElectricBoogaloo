//
//  summaryViewController.swift
//  GridRace
//
//  Created by Christian on 3/7/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    let mainTextLabel = UILabel()
    let mainValueLabel = UILabel()
    let bonusTextLabel = UILabel()
    let bonusValueLabel = UILabel()
    let timeTextLabel = UILabel()
    let timeValueLabel = UILabel()
    let pointsTextLabel = UILabel()
    let pointsValueLabel = UILabel()
    let summaryTableView = UITableView()
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
        
        //table view set up
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
        summaryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        summaryTableView.tableFooterView = UIView()
        summaryTableView.backgroundColor = AppColors.backgroundColor

        setUpLayout()

        updateLabels()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = AppColors.backgroundColor
        collectionView.register(ObjectiveSummaryCollectionViewCell.self, forCellWithReuseIdentifier: "objectiveCell")
        
        mainTextLabel.text = "Main Objectives: "
        bonusTextLabel.text = "Bonus Objectives: "
        timeTextLabel.text = "Time: "
        pointsTextLabel.text = "Points: "
        timeValueLabel.text = "\(finishTime)"
    }

    func updateLabels() {
        mainValueLabel.text = "\(completedPlacesObjectivesCount)/\(mainObjectives.count)"
        bonusValueLabel.text = "\(completedBonusObjectivesCount)/\(bonusObjectives.count)"
        pointsValueLabel.text = "\(userPoints)/\(totalPoints)"
    }

    func setUpLayout() {
        
        //add items to view
        view.addSubview(summaryTableView)
        view.addSubview(collectionView)
        
        //layout constraints
        
        summaryTableView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

//        let views: [String: Any] = [
//            "mainTextLabel" : mainTextLabel,
//            "mainValueLabel" : mainValueLabel,
//            "bonusTextLabel" : bonusTextLabel,
//            "bonusValueLabel" : bonusValueLabel,
//            "timeTextLabel" : timeTextLabel,
//            "timeValueLabel" : timeValueLabel,
//            "pointsTextLabel" : pointsTextLabel,
//            "pointsValueLabel" : pointsValueLabel
//        ]
//
//        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-32-[mainTextLabel]-[bonusTextLabel]-[timeTextLabel]-[pointsTextLabel]", options: [.alignAllLeading], metrics: nil, views: views)
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[mainValueLabel]-[bonusValueLabel]-[timeValueLabel]-[pointsValueLabel]", options: [.alignAllLeading], metrics: nil, views: views)
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[mainTextLabel]-32-[mainValueLabel]", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)

        NSLayoutConstraint.activate([
            //summary table view
            summaryTableView.topAnchor.constraint(equalTo: view.topAnchor),
            summaryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryTableView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),

            
            
            //collection view
            collectionView.heightAnchor.constraint(equalToConstant: 350),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    
    }
    
    override func viewDidLayoutSubviews() {
        if !(collectionView.collectionViewLayout is CustomFlowLayout) {
            collectionView.collectionViewLayout = CustomFlowLayout(collectionViewWidth: collectionView.frame.width, collectionViewHeigth: collectionView.frame.height, itemSizePoints: 220)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateCells()
    }
    
    func animateCells() {
        guard collectionView.numberOfItems(inSection: 0) > 0 else {
            return
        }
        
        if let layout = collectionView.collectionViewLayout as? CustomFlowLayout {
            let pageWidth = layout.pageWidth()
            //get index of the current cell using the page width (which is the difference the leading side of each cell)
            let index: Int = Int(round(collectionView.contentOffset.x / pageWidth))
            
            if index < 0 || index > allObjectives.count - 1 {
                return
            }
            
            let indexForVisibleCell = IndexPath(item: index, section: 0)
            //save the middle cell
            let cellToZoom = collectionView.cellForItem(at: indexForVisibleCell) as! ObjectiveSummaryCollectionViewCell
            
            //animate cells, making the middle one larger and all the other ones their original size in case they have changed
            UIView.animate(withDuration: 0.05, animations: {
                for (cell) in (self.collectionView.visibleCells as! [ObjectiveSummaryCollectionViewCell]) {
                    if cell == cellToZoom {
                        cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    } else {
                        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                }
            })
        }
    }

    //MARK:- collectionView delegate methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allObjectives.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = allData.first(where: {$0.objectiveID == allObjectives[indexPath.row].id})
        data!.correct = !(data!.correct)
        
        let cell = collectionView.cellForItem(at: indexPath) as! ObjectiveSummaryCollectionViewCell
        
        cell.contentView.backgroundColor = data!.correct ? #colorLiteral(red: 0.1529411765, green: 0.6823529412, blue: 0.3764705882, alpha: 1) : #colorLiteral(red: 0.7529411765, green: 0.2235294118, blue: 0.168627451, alpha: 1)
        
        updateLabels()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "objectiveCell", for: indexPath) as! ObjectiveSummaryCollectionViewCell

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


        cell.contentView.backgroundColor = userData!.correct ? #colorLiteral(red: 0.1529411765, green: 0.6823529412, blue: 0.3764705882, alpha: 1) : #colorLiteral(red: 0.7529411765, green: 0.2235294118, blue: 0.168627451, alpha: 1)

        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate else {
            return
        }
        animateCells()
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateCells()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = summaryTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "hey"
        cell.textLabel?.textColor = AppColors.textPrimaryColor
        cell.backgroundColor = AppColors.backgroundColor
        return cell
    }
    


}
