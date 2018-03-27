//
//  DataManager.swift
//  GridRace
//
//  Created by Christian on 3/26/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

protocol DataManagerDelgate {

    func didRetriveData(alert: UIAlertController?)
}

class DataManager: NSObject, DetailViewControllerDelegate {

    var delegate: DataManagerDelgate? = nil

    func objectivesFilePath() -> URL {
        return AppResources.documentsDirectory().appendingPathComponent("Objectives.plist")
    }

    func userDataFilePath() -> URL {
        return AppResources.documentsDirectory().appendingPathComponent("UserData.plist")
    }

    func saveLocalData() {
        let encoder = PropertyListEncoder()
        do {
            //encode data
            let objectivesDataToWrite = try encoder.encode(AppResources.ObjectiveData.sharedObjectives.objectives)
            let userDataToWrite = try encoder.encode(AppResources.ObjectiveData.sharedObjectives.data)

            //write to files
            try objectivesDataToWrite.write(to: objectivesFilePath())
            try userDataToWrite.write(to: userDataFilePath())

        } catch {
            print ("Something went wrong when saving")
        }

    }

    func initiateSave() {
        print("Saving!")
        saveLocalData()
    }


    func loadLocalData() {

        var returnAlert: UIAlertController? = nil

        //load objectives, points and completed data
        if let objectivesDataToRead = try? Data(contentsOf: objectivesFilePath()), let userDataToRead = try? Data(contentsOf: userDataFilePath()) {
            let decoder = PropertyListDecoder()
            do {
                let objectives = try decoder.decode([Objective].self, from: objectivesDataToRead)
                for (objective) in objectives {
                    AppResources.ObjectiveData.sharedObjectives.objectives.append(objective)
                }
                let data = try decoder.decode([ObjectiveUserData].self, from: userDataToRead)
                for (item) in data {
                    AppResources.ObjectiveData.sharedObjectives.data.append(item)
                }
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
        AppResources.returnDownloadedObjectives() {tempObjectives in
            if tempObjectives.isEmpty {
                let alert = UIAlertController(title: "Failed to download!", message: "Using locally saved data fow now, however we recommend restarting with app whilst having an internet connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                returnAlert = alert
                self.delegate?.didRetriveData(alert: returnAlert)
            }

            //bool to determine whether to show "data was reset" alert
            var dataReset = false

            //check that they are the same length and have the same data, reset if not
            if tempObjectives.count == AppResources.ObjectiveData.sharedObjectives.objectives.count {
                for (index, objective) in tempObjectives.enumerated() {
                    if !(objective == AppResources.ObjectiveData.sharedObjectives.objectives[index]) {
                        AppResources.ObjectiveData.sharedObjectives.objectives = tempObjectives
                        self.resetLocalData()
                        dataReset = true
                        UserDefaults.standard.set(Date(), forKey: "FirstLaunchDate")
                        break
                    }
                }
            } else {
                //we don't want to set dataReset to be true if objectives.count is 0, which means they're setting up the app for the first time
                if AppResources.ObjectiveData.sharedObjectives.objectives.count != 0 {
                    dataReset = true
                }
                AppResources.ObjectiveData.sharedObjectives.objectives = tempObjectives
                self.resetLocalData()
            }

            //alert the user if their data has been reset
            if dataReset {
                let alert = UIAlertController(title: "Data Reset!", message: "Application did not have up to date data, and so it has been reset", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                returnAlert = alert
            }
            self.saveLocalData()
            self.delegate?.didRetriveData(alert: returnAlert)

        }
    }

    func deleteDocumentData() {
        do {
            try FileManager.default.removeItem(at: objectivesFilePath())
            try FileManager.default.removeItem(at: userDataFilePath())
            for (data) in AppResources.ObjectiveData.sharedObjectives.data {
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
        AppResources.ObjectiveData.sharedObjectives.data.removeAll()
        for (objective) in AppResources.ObjectiveData.sharedObjectives.objectives {
            AppResources.ObjectiveData.sharedObjectives.data.append(ObjectiveUserData(id: objective.id))
        }


        //save this information
        saveLocalData()
    }


}


