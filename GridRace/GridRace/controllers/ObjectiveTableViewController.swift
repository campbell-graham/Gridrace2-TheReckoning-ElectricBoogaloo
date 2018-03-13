//
//  ObjectiveTableViewController.swift
//  GridRace
//
//  Created by Campbell Graham on 27/2/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ObjectiveTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ObjectiveTableViewControllerDelegate  {
    
    var tableView = UITableView()
    var dataCategory: ObjectiveCategory
    var containedObjectiveData: AppResources.ObjectiveData
    
    var incompleteObjectives = [Objective]() {
        didSet {
            tableView.reloadData()
        }
    }
    var completeObjectives = [Objective]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //will eventually take in data
    init(title: String, tabBarImage: UIImage, dataCategory: ObjectiveCategory, coreObjectData: AppResources.ObjectiveData) {
        self.containedObjectiveData = coreObjectData
        self.dataCategory = dataCategory
        super.init(nibName: nil, bundle: nil)
        self.title = title
        tabBarItem = UITabBarItem(title: self.title, image: tabBarImage, selectedImage: tabBarImage)
        //start a load of local data which will also make comparisons with the data that firebase has
        loadLocalData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.reloadData()
    }
    
    func sortObjectives() {
        completeObjectives.removeAll()
        incompleteObjectives.removeAll()
        for (objective) in containedObjectiveData.objectives {
            if let x = containedObjectiveData.data.first(where: {$0.objectiveID == objective.id})  {
                if x.completed {
                    completeObjectives.append(objective)
                } else {
                    incompleteObjectives.append(objective)
                }
            } else {
                incompleteObjectives.append(objective)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func objectivesFilePath() -> URL {
        return AppResources.documentsDirectory().appendingPathComponent("Objectives_\(dataCategory.rawValue).plist")
    }
    
    func userDataFilePath() -> URL {
        return AppResources.documentsDirectory().appendingPathComponent("UserData_\(dataCategory.rawValue).plist")
    }
    
    func saveLocalData() {
        let encoder = PropertyListEncoder()
        do {
            //encode data
            let objectivesDataToWrite = try encoder.encode(containedObjectiveData.objectives)
            let userDataToWrite = try encoder.encode(containedObjectiveData.data)
            
            //write to files
            try objectivesDataToWrite.write(to: objectivesFilePath())
            try userDataToWrite.write(to: userDataFilePath())
            
        } catch {
            print ("Something went wrong when saving")
        }
        
        //sort at the end of saving
        sortObjectives()
    }
    
    func initiateSave() {
        print("Saving!")
        saveLocalData()
    }
    
    
    func loadLocalData() {
        //load objectives, points and completed data
        if let objectivesDataToRead = try? Data(contentsOf: objectivesFilePath()), let userDataToRead = try? Data(contentsOf: userDataFilePath()) {
            let decoder = PropertyListDecoder()
            do {
                containedObjectiveData.objectives = try decoder.decode([Objective].self, from: objectivesDataToRead)
                containedObjectiveData.data = try decoder.decode([ObjectiveUserData].self, from: userDataToRead)
                sortObjectives()
            } catch {
                print("Error decoding the local array, will re-download")
                //delete local files if there are issues assiging to local variables
                resetLocalData()
            }
        } else {
            //files don't exist or have issues so reset
            resetLocalData()
        }
        
        //a download is always called at the end so that comparisons can be made, and local data overwritten if it is no longer valid. Wait until download is complete and then run comparisons with local data
        AppResources.returnDownloadedObjectives(dataCategory: self.dataCategory) {tempObjectives in
            if tempObjectives.isEmpty {
                let alert = UIAlertController(title: "Failed to download for \(self.dataCategory.rawValue.capitalized)!", message: "We were unable to download up to date data, so please note that the objectives in this app may not be accurate", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            //bool to determine whether to show "data was reset" alert
            var dataReset = false
            
            //check that they are the same length and have the same data, reset if not
            if tempObjectives.count == self.containedObjectiveData.objectives.count {
                for (index, objective) in tempObjectives.enumerated() {
                    if !(objective == self.containedObjectiveData.objectives[index]) {
                        self.containedObjectiveData.objectives = tempObjectives
                        self.resetLocalData()
                        dataReset = true
                        UserDefaults.standard.set(Date(), forKey: "FirstLaunchDate")
                        break
                    }
                }
            } else {
                //we don't want to set dataReset to be true if objectives.count is 0, which means they're setting up the app for the first time
                if self.containedObjectiveData.objectives.count != 0 {
                    dataReset = true
                }
                self.containedObjectiveData.objectives = tempObjectives
                self.resetLocalData()
            }
            
            //alert the user if their data has been reset
            if dataReset {
                let alert = UIAlertController(title: "Data Reset!", message: "Application did not have up to date data for the section '\(self.dataCategory.rawValue)', and so it has been reset.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func deleteDocumentData() {
        do {
            try FileManager.default.removeItem(at: objectivesFilePath())
            try FileManager.default.removeItem(at: userDataFilePath())
            for (data) in containedObjectiveData.data {
                if let imageURL = data.imageResponseURL {
                    try FileManager.default.removeItem(at: imageURL)
                }
            }
        } catch {
            print("Error deleting documents")
        }
    }
    
    func resetLocalData() {
        //delete everything from local documents
        deleteDocumentData()
        
        //re-populate user data
        containedObjectiveData.data.removeAll()
        for (objective) in containedObjectiveData.objectives {
            containedObjectiveData.data.append(ObjectiveUserData(id: objective.id))
        }
        
        
        //save this information
        saveLocalData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //styling
        view.backgroundColor = AppColors.backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.backgroundColor = AppColors.backgroundColor
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = AppColors.textSecondaryColor
        
        //table view setup
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ObjectiveTableViewCell.self, forCellReuseIdentifier: "ObjectiveCell")
        tableView.register(CustomTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        //add items to view
        view.addSubview(tableView)
        
        //layout constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return incompleteObjectives.count
        case 1:
            return completeObjectives.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //return a blank view for the header if that section does not have any objectives
        if section == 0 && incompleteObjectives.count == 0 {
            return UIView()
        } else if section == 1 && completeObjectives.count == 0 {
            return UIView()
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomTableHeaderView
        switch section {
        case 0:
            headerView.titleLabel.text = "Incomplete"
        case 1:
            headerView.titleLabel.text = "Complete"
        default:
            break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        var objective: Objective?
        
        switch indexPath.section {
        case 0 :
            objective = incompleteObjectives[indexPath.row]
        case 1 :
            objective = completeObjectives[indexPath.row]
        default:
            print("invalid section")
        }
        
        //ensure that it found a valid object
        guard let obj = objective else {
            return
        }
        
        let data = containedObjectiveData.data.first(where: {$0.objectiveID == obj.id})
        let destination = MapViewController(objective: obj, data: data!)
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectiveCell", for: indexPath) as! ObjectiveTableViewCell
        let objective = indexPath.section == 0 ? incompleteObjectives[indexPath.row] : completeObjectives[indexPath.row]
        
        cell.titleLabel.text = objective.name
        if let points = containedObjectiveData.data.first(where: {$0.objectiveID == objective.id})?.adjustedPoints {
            cell.pointsLabel.text = String(points)
        } else {
            cell.pointsLabel.text = String(objective.points)
        }
        
        
        //set font to heavy if complete
        
        cell.titleLabel.font = indexPath.section == 0 ? UIFont.systemFont(ofSize: 16, weight: .ultraLight) : UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return cell
    }
}

protocol ObjectiveTableViewControllerDelegate: class {
    func initiateSave()
}
