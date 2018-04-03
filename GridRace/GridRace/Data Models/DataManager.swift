//
//  DataManager.swift
//  GridRace
//
//  Created by Christian on 3/26/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DataManager: NSObject {

    var delegate: DataManagerDelgate?
    let fireBaseDownloader = FireBaseDownloader()

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

    func loadLocalData() {
        //load objectives, points and completed data
        if let objectivesDataToRead = try? Data(contentsOf: objectivesFilePath()), let userDataToRead = try? Data(contentsOf: userDataFilePath()) {
            let decoder = PropertyListDecoder()
            do {
                let objectives = try decoder.decode([Objective].self, from: objectivesDataToRead)
                for (objective) in objectives {
                    fireBaseDownloader.downloadImage(objectiveID: objective.id)
                    AppResources.ObjectiveData.sharedObjectives.objectives.append(objective)
                }
                let data = try decoder.decode([ObjectiveUserData].self, from: userDataToRead)
                for (item) in data {
                    AppResources.ObjectiveData.sharedObjectives.data.append(item)
                }
            } catch {
                print("Error decoding the local array, will re-download")
                //delete local files if there are issues assiging to local variables
                resetLocalData(objectivesToResetWith: [Objective]())
            }
        } else {
            //files don't exist or have issues so reset
            resetLocalData(objectivesToResetWith: [Objective]())
        }
        
        //a download is always called at the end so that comparisons can be made, and local data overwritten if it is no longer valid
        downloadAndCompare()
       
    }
    
    func downloadAndCompare() {
        var returnAlert: UIAlertController? = nil
        //wait until download is complete and then run comparisons with local data
        returnDownloadedObjectives() {tempObjectives in
            if tempObjectives.isEmpty {
                let alert = UIAlertController(title: "Failed to download!", message: "Using locally saved data fow now, however we recommend restarting with app whilst having an internet connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                returnAlert = alert
                self.delegate?.didRetrieveData(alert: returnAlert)
                //return as we do not want to run download comparisons
                return
            }
            
            //bool to determine whether to show "data was reset" alert
            var dataReset = false
            
            //check that they are the same length and have the same data, reset if not
            if tempObjectives.count == AppResources.ObjectiveData.sharedObjectives.objectives.count {
                for (index, objective) in tempObjectives.enumerated() {
                    if objective != AppResources.ObjectiveData.sharedObjectives.objectives[index] && !dataReset {
                        self.resetLocalData(objectivesToResetWith: tempObjectives)
                        dataReset = true
                    }
                }
            } else {
                //we don't want to set dataReset to be true if objectives.count is 0, which means they're setting up the app for the first time
                if AppResources.ObjectiveData.sharedObjectives.objectives.count != 0 {
                    dataReset = true
                }
                self.resetLocalData(objectivesToResetWith: tempObjectives)
            }
            
            //alert the user if their data has been reset
            if dataReset {
                let alert = UIAlertController(title: "Data Reset!", message: "Application did not have up to date data, and so it has been reset", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                returnAlert = alert
            }
            self.saveLocalData()
            self.delegate?.didRetrieveData(alert: returnAlert)
        }
    }
    
    func returnDownloadedObjectives(completion: @escaping (([Objective]) -> ())) {
        //download if doesn't exist already
        
        var hasConnection = false
        
        var downloadedObjectives = [Objective]()
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                hasConnection = true
            } else {
                hasConnection = false
            }
        })
        
        //if no connection after 10 seconds, return blank objectives so the main controller knows it cannot connect
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
            if !hasConnection {
                completion([Objective]())
            }
        }
        
        let ref = Database.database().reference()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            do {
                if let dict = snapshot.value as? [String: Any] {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonDecoder = JSONDecoder()
                    downloadedObjectives = try jsonDecoder.decode(ObjectList.self, from: data).data
                    completion(downloadedObjectives)
                }
            } catch {
                print(error)
            }
        })
        
        
        
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

    func resetLocalData(objectivesToResetWith: [Objective]) {
        //delete everything from local documents
        deleteDocumentData()
        
        AppResources.ObjectiveData.sharedObjectives.objectives = objectivesToResetWith

        //re-populate user data
        for (objective) in AppResources.ObjectiveData.sharedObjectives.objectives {
            AppResources.ObjectiveData.sharedObjectives.data.append(ObjectiveUserData(id: objective.id))
        }

        //since the app is resetting data, we should reset the first launch date
        UserDefaults.standard.set(Date(), forKey: "FirstLaunchDate")

        //save this information
        saveLocalData()
    }


}

protocol DataManagerDelgate {
    func didRetrieveData(alert: UIAlertController?)
}



