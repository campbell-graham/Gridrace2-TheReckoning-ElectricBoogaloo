//
//  ObjectiveTableViewController.swift
//  GridRace
//
//  Created by Campbell Graham on 27/2/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ObjectiveTableViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    let segmentItems = [ObjectiveType.main.rawValue.capitalized, ObjectiveType.bonus.rawValue.capitalized]
    let segmentedControl: UISegmentedControl
    let mapView: MKMapView = MKMapView()
    let locationManager = CLLocationManager()
    var objectivesToDisplay = [Objective]()
    var currentAnnotations = [String: MKAnnotation]()
    var buttonsView = UIView()
    var resetMapButton = UIButton(type: UIButtonType.system)
    var showUserLocationButton = UIButton(type: UIButtonType.system)

    var timerView = TimerView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))

    //used for cell animation
    var detailViewController: DetailViewController?
    var detailView: UIView?
    var cellFrame: CGRect?
    let detailViewSnapShotImageView = UIImageView()
    let cellSnapShotImageView = UIImageView()

    //used for pan animation
    private var collapsableDetailsAnimator: UIViewPropertyAnimator?
    
    lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    //will eventually take in data
    init() {
        //segmented control set up
        segmentedControl = UISegmentedControl(items: segmentItems)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = AppColors.orangeHighlightColor
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .medium)],
                                                for: .normal)

        super.init(nibName: nil, bundle: nil)
        
        //tell segmented control to update every time selected value is changed
        segmentedControl.addTarget(self, action: #selector(handleSegmentedChanged), for: .valueChanged)
        
        title = "Objectives"
        
        //start a load of local data which will also make comparisons with the data that firebase has
        loadLocalData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: timerView)
        
        //styling
        view.backgroundColor = AppColors.backgroundColor

        //styling for animation imageViews
        detailViewSnapShotImageView.layer.cornerRadius = 10
        cellSnapShotImageView.layer.cornerRadius = 10

        detailViewSnapShotImageView.layer.masksToBounds = true
        cellSnapShotImageView.layer.masksToBounds = true
        
        //map set up
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        mapView.delegate = self
        
        //buttons view set up
        showUserLocationButton.setImage(#imageLiteral(resourceName: "directional_arrow").withRenderingMode(.alwaysTemplate), for: .normal)
        showUserLocationButton.imageView?.tintColor = UIColor.blue
        showUserLocationButton.addTarget(self, action: #selector(showUserLocation), for: .touchUpInside)
        resetMapButton.setImage(#imageLiteral(resourceName: "target").withRenderingMode(.alwaysTemplate), for: .normal)
        resetMapButton.imageView?.tintColor = UIColor.blue
        resetMapButton.addTarget(self, action: #selector(zoomToLocation), for: .touchUpInside)
        buttonsView.layer.cornerRadius = 16
        //buttonsView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        buttonsView.layer.shadowColor = UIColor.black.cgColor
        buttonsView.layer.shadowOpacity = 1
        buttonsView.layer.shadowOffset = CGSize.zero
        buttonsView.layer.shadowRadius = 4
        
        //add buttons to buttons view
        buttonsView.addSubview(showUserLocationButton)
        buttonsView.addSubview(resetMapButton)
        
        //add items to view
        navigationItem.titleView = segmentedControl
        view.addSubview(mapView)
        view.addSubview(collectionView)
        view.addSubview(buttonsView)
        
        //collection view st up
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        collectionView.register(ObjectiveInformationCollectionViewCell.self, forCellWithReuseIdentifier: "objectiveCell")
        
        //layout constraints
        mapView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        showUserLocationButton.translatesAutoresizingMaskIntoConstraints = false
        resetMapButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //map view
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            //collection view
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            
            //buttons view
            buttonsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            buttonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            buttonsView.widthAnchor.constraint(equalToConstant: 50),
            buttonsView.heightAnchor.constraint(equalToConstant: 100),
            
            //user location button
            showUserLocationButton.topAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            showUserLocationButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            showUserLocationButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            showUserLocationButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            
            //reset map button
            resetMapButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            resetMapButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            resetMapButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            resetMapButton.bottomAnchor.constraint(equalTo: buttonsView.centerYAnchor)
            ])
    }
    
    override func viewDidLayoutSubviews() {

        if !(collectionView.collectionViewLayout is CustomFlowLayout) {
            collectionView.collectionViewLayout = CustomFlowLayout(collectionViewWidth: collectionView.frame.width, collectionViewHeigth: collectionView.frame.height, itemSizePoints: 200)
//            collectionView.layoutIfNeeded()
            mapView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: collectionView.frame.height, right: 16)
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = buttonsView.bounds
            blurEffectView.layer.cornerRadius = buttonsView.layer.cornerRadius
            blurEffectView.clipsToBounds = true
            buttonsView.addSubview(blurEffectView)
            buttonsView.sendSubview(toBack: blurEffectView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //ask permission for user location  (also had to add "NSLocationWhenInUseUsageDescription" to Info.plist file)
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        // if permission denied show popup alert
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }

        collectionView.reloadData()
        collectionView.performBatchUpdates({}, completion: { (finished) in
                self.animateCellsOnSwipe()
        })
    }


    func animateCellsOnSwipe() {
        guard collectionView.numberOfItems(inSection: 0) > 0 else {
            return
        }
        
        if let layout = collectionView.collectionViewLayout as? CustomFlowLayout {
            let pageWidth = layout.pageWidth()
            //get index of the current cell using the page width (which is the difference the leading side of each cell)
            let index: Int = Int(round(collectionView.contentOffset.x / pageWidth))
            
            if index < 0 || index > objectivesToDisplay.count - 1 {
                return
            }
            
            let indexForVisibleCell = IndexPath(item: index, section: 0)
            //save the middle cell
            let cellToZoom = collectionView.cellForItem(at: indexForVisibleCell) as! ObjectiveInformationCollectionViewCell
            
            //animate cells, making the middle one larger and all the other ones their original size in case they have changed
            UIView.animate(withDuration: 0.05, animations: {
                for (cell) in (self.collectionView.visibleCells as! [ObjectiveInformationCollectionViewCell]) {
                    if cell == cellToZoom {
                        cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    } else {
                        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                }
            })
        }
    }
    
    @objc func zoomToLocation() {
        if let layout = collectionView.collectionViewLayout as? CustomFlowLayout {
            let pageWidth = layout.pageWidth()
            //get index of the current cell using the page width (which is the difference the leading side of each cell)
            let index: Int = Int(round(collectionView.contentOffset.x / pageWidth))
            
            if index < 0 || index > objectivesToDisplay.count - 1 {
                return
            }
            
            //zoom to location on map
            if let coordinate = currentAnnotations[objectivesToDisplay[index].id]?.coordinate {
                //make circle orange
                let circle = currentAnnotations[objectivesToDisplay[index].id] as! MKCircle
                for (overlay) in mapView.overlays as! [MKCircle] {
                    let circleRenderer = (mapView.renderer(for: overlay) as! MKCircleRenderer)
                    if overlay == circle {
                        circleRenderer.fillColor = AppColors.orangeHighlightColor.withAlphaComponent(0.7)
                    } else {
                        circleRenderer.fillColor = AppColors.cellColor.withAlphaComponent(0.3)
                    }
                }
                
                let latDelta: CLLocationDegrees = 0.005
                let lonDelta: CLLocationDegrees = 0.005
                let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
                mapView.setRegion(region, animated: true)
            } else {
                for (overlay) in mapView.overlays as! [MKCircle] {
                    let circleRenderer = (mapView.renderer(for: overlay) as! MKCircleRenderer)
                    circleRenderer.fillColor = AppColors.cellColor.withAlphaComponent(0.7)
                }
                mapView.setRegion(region(for: Array(currentAnnotations.values)), animated: true)
            }
        }
    }
    
    @objc func showUserLocation() {
        mapView.setRegion(region(for: [MKAnnotation]()), animated: true)
    }

    //MARK:- CollectionView delegate methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objectivesToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        growCellAnimationSetup(cell: collectionView.cellForItem(at: indexPath)!)

        UIView.animate(withDuration: 0.3, animations: {

            //make cell snapShot transparent to reveal detailView snapshot below it
            self.cellSnapShotImageView.alpha = 0

            //grow both snapshots to full size
            self.cellSnapShotImageView.frame = self.detailView!.frame
            self.detailViewSnapShotImageView.frame = self.detailView!.frame

            self.mapView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: self.detailView!.frame.height - 16, right: 16)
            self.zoomToLocation()
        }, completion: { _ in

            //remove the snapshots
            self.detailViewSnapShotImageView.removeFromSuperview()
            self.cellSnapShotImageView.removeFromSuperview()

            //reveal the detailView
            self.detailView!.isHidden = false
        })

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "objectiveCell", for: indexPath) as! ObjectiveInformationCollectionViewCell

        let objective = objectivesToDisplay[indexPath.row]
        let data = AppResources.ObjectiveData.sharedObjectives.data.first(where: {$0.objectiveID == objective.id})

        cell.titleLabel.text = objective.name
        cell.pointsLabel.text = "\(objective.points) Points"
        cell.descriptionLabel.text = objective.desc
        if (data!.completed) {
            cell.tickImageView.tintColor = AppColors.greenHighlightColor
        } else {
            cell.tickImageView.tintColor = AppColors.textSecondaryColor
        }

        //add panGesture recogniser to cell
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(collapseAnimationHandler))
        panGestureRecogniser.delegate = self
        cell.addGestureRecognizer(panGestureRecogniser)

        return cell
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- Segment Control

    @objc func handleSegmentedChanged() {
        updateSelectedObjectiveType()
    }
    
    @objc func updateSelectedObjectiveType() {
        let selectedObjectiveTypeAsString = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)?.lowercased()
        let objectiveTypeToFilter = ObjectiveType(rawValue: selectedObjectiveTypeAsString!)
        objectivesToDisplay = AppResources.ObjectiveData.sharedObjectives.objectives.filter({$0.objectiveType == objectiveTypeToFilter})
        collectionView.reloadData()
        //executes when the reload data is complete
        self.collectionView.performBatchUpdates({}, completion: { (finished) in
            self.addMapCircles()
            self.animateCellsOnSwipe()
            self.zoomToLocation()
        })
        collectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        
        //set follow mode if bonus, eitherwise turn off
        if objectiveTypeToFilter == .bonus {
            mapView.userTrackingMode = .follow
        } else {
            mapView.userTrackingMode = .none
        }
    }

    //MARK:- Map methods
    
    func addMapCircles() {
        let radius: Double = 150
        
        //remove all old pins
        for (pin) in currentAnnotations {
            mapView.remove(pin.value as! MKCircle)
        }
        
        //empty current annotations
        currentAnnotations.removeAll()
        
        //zoom map to show new locations
        for (objective) in objectivesToDisplay.filter({$0.coordinate != nil}) {
            let coordinate = CLLocationCoordinate2D(latitude: objective.latitude!, longitude: objective.longitude!)
            // generate a random offset in meters that is within the radius (so that the objective location will fall in new circle)
            let randOffset = coordinate.latitude + (randBetween(lower: Int(round(-radius / 3)), upper: Int(round(radius / 3))) as CLLocationDistance)
            
            // use offset to create a new random center for the overlay circle
            let randCenter = locationWithBearing(bearing: randOffset, distanceMeters: randOffset, origin: coordinate)
            
            let circle = MKCircle(center: randCenter, radius: radius as CLLocationDistance)
            mapView.add(circle)
            currentAnnotations[objective.id] = circle
        }
        mapView.setRegion(region(for: Array(currentAnnotations.values)), animated: true)
    }
    
    func randBetween(lower: Int, upper: Int) -> Double {
        return Double( Int(arc4random_uniform(UInt32(upper - lower))) + lower)
    }
    
    // magic from internet to offset a location coordinate by meters (bearing is the direction to offset [in degress])
    func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6)
        
        let rbearing = bearing * Double.pi / 180.0
        
        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(rbearing))
        let lon2 = lon1 + atan2(sin(rbearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
    
    func region(for annotations: [MKAnnotation]) ->
        MKCoordinateRegion {
            let region: MKCoordinateRegion
            switch annotations.count {
            case 0:
                region = MKCoordinateRegionMakeWithDistance(
                    mapView.userLocation.coordinate, 1000, 1000)
            case 1:
                let annotation = annotations[annotations.count - 1]
                region = MKCoordinateRegionMakeWithDistance(
                    annotation.coordinate, 1000, 1000)
            default:
                var topLeft = CLLocationCoordinate2D(latitude: -90,
                                                     longitude: 180)
                var bottomRight = CLLocationCoordinate2D(latitude: 90,
                                                         longitude: -180)
                for annotation in annotations {
                    topLeft.latitude = max(topLeft.latitude,
                                           annotation.coordinate.latitude)
                    topLeft.longitude = min(topLeft.longitude,
                                            annotation.coordinate.longitude)
                    bottomRight.latitude = min(bottomRight.latitude,
                                               annotation.coordinate.latitude)
                    bottomRight.longitude = max(bottomRight.longitude,
                                                annotation.coordinate.longitude)
                }
                let center = CLLocationCoordinate2D(
                    latitude: topLeft.latitude -
                        (topLeft.latitude - bottomRight.latitude) / 2,
                    longitude: topLeft.longitude -
                        (topLeft.longitude - bottomRight.longitude) / 2)
                let extraSpace = 1.1
                let span = MKCoordinateSpan(
                    latitudeDelta: abs(topLeft.latitude -
                        bottomRight.latitude) * extraSpace,
                    longitudeDelta: abs(topLeft.longitude -
                        bottomRight.longitude) * extraSpace)
                region = MKCoordinateRegion(center: center, span: span)
            }
            return mapView.regionThatFits(region)
    }

    //MARK:- Data saving/loading methods
    
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
                self.present(alert, animated: true, completion: nil)
                self.updateSelectedObjectiveType()
                return
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
                self.present(alert, animated: true, completion: nil)
            }
            self.saveLocalData()
            self.updateSelectedObjectiveType()
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

    //MARK:- map stuff

    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        present(alert, animated: true, completion: nil)
        alert.addAction(okAction)
    }
    
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = AppColors.orangeHighlightColor
            circle.fillColor = AppColors.cellColor.withAlphaComponent(0.7)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }

    //MARK:- scroll view delegate methods

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate else {
            return
        }
        animateCellsOnSwipe()
        zoomToLocation()
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateCellsOnSwipe()
        zoomToLocation()
    }

    //MARK:- cell animation code

    private func growCellAnimationSetup(cell: UICollectionViewCell) {

        let indexPath = collectionView.indexPath(for: cell)

        let objective = objectivesToDisplay[indexPath!.row]
        let data = AppResources.ObjectiveData.sharedObjectives.data.first(where: {$0.objectiveID == objective.id})

        self.detailViewController = DetailViewController(objective: objective, data: data!)
        detailViewController?.delegate = self
        addChildViewController(detailViewController!)
        detailViewController!.didMove(toParentViewController: self)
        detailView = detailViewController!.view

        //set up detailView animation panGestureRecognizer
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(collapseAnimationHandler))
        panGestureRecogniser.delegate = self
        detailView!.addGestureRecognizer(panGestureRecogniser)

        if cellFrame == nil {

            cellFrame = CGRect(x: ((view.frame.width / 2) - (cell.frame.width / 2)), y: collectionView.frame.minY + cell.frame.minY, width: cell.frame.width, height: cell.frame.height)
        }

        // take snapshot of tapped cell
        cellSnapShotImageView.frame = cellFrame!
        cellSnapShotImageView.image = cell.contentView.takeSnapshot(bounds: cell.bounds)

        //add the detailView and assign it a frame with 60% height
        self.view.addSubview(detailView!)
        detailView!.frame = CGRect(x: 0, y: self.view.frame.height * 0.4, width: self.view.frame.width, height: self.view.frame.height * 0.6)

        //take snapShot of full detailView
        detailViewSnapShotImageView.frame = detailView!.frame
        detailViewSnapShotImageView.image = detailView!.takeSnapshot(bounds: detailView!.bounds)

        //shrink detailView snapshot to size of cell
        detailViewSnapShotImageView.frame = cellFrame!

        //hide the full sized detail view
        detailView!.isHidden = true

        //add both snapshots to view (cell snap ontop)
        view.addSubview(detailViewSnapShotImageView)
        view.addSubview(cellSnapShotImageView)

        // ensure both snapshots are opaque
        self.cellSnapShotImageView.alpha = 1
        self.detailViewSnapShotImageView.alpha = 1
    }

    private  func shrinkCellAnimationSetUp() {

        //add the snapshot imageViews back to view
        view.addSubview(cellSnapShotImageView)
        view.addSubview(detailViewSnapShotImageView)

        //retake detail snapshot as it may have changed (we can however reuse the cellSnapshot taken when growing the cell)
        detailViewSnapShotImageView.image = detailView!.takeSnapshot(bounds: detailView!.bounds)

        // hide the detailView
        self.detailView?.isHidden = true

        // ensure both snapshots are completley opaque
        self.cellSnapShotImageView.alpha = 1
        self.detailViewSnapShotImageView.alpha = 1
    }

    //MARK:- pan animation code

    // the value between the animated views highest possible point and lowest possible point
    private var totalYMovement: CGFloat = 0.0

    @objc private func collapseAnimationHandler(recognizer: UIPanGestureRecognizer) {

        // translation is a numeric value that represents how much pixels the user has moved from start of panning
        let translation = recognizer.translation(in: view)


        if recognizer.state == .began {

            // on start of user panning, set destination frame of the animated viewController
            onPanBegin(recognizer: recognizer)
        }

        if recognizer.state == .ended {

            let velocity = recognizer.velocity(in: view)
            // when the user stops panning, decide where the collapsible view should bounce back to
            panningEndedWithTranslation(recognizer: recognizer, translation: translation, velocity: velocity)
        }
        else {
            // whilst the user is panning translate the progress of the panning animaition
            panningChangedWithTranslation( recognizer: recognizer, translation: translation)
        }
    }

    private func onPanBegin(recognizer: UIPanGestureRecognizer) {

        if let animator = collapsableDetailsAnimator, animator.isRunning {
            return
        }

        // if the user is panning from cell to detailView
        if let cell = recognizer.view as? UICollectionViewCell {

            growCellAnimationSetup(cell: cell)

            totalYMovement = cellFrame!.minY - detailView!.frame.minY

            collapsableDetailsAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn, animations: {

                //make cell snapShot transparent to reveal detailView snapshot below it
                self.cellSnapShotImageView.alpha = 0

                //grow both snapshots to full size
                self.cellSnapShotImageView.frame = self.detailView!.frame
                self.detailViewSnapShotImageView.frame = self.detailView!.frame

                //update maps current content insets
                self.mapView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: self.detailView!.frame.height + 16, right: 16)
                self.zoomToLocation()
            })

        // else if user is panning from detailView back down to a cell
        } else {

            shrinkCellAnimationSetUp()

            if detailView != nil {
                totalYMovement = cellFrame!.minY - detailView!.frame.minY
            }

            collapsableDetailsAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn, animations: {

                //make detailView snapShot transparent to reveal cell snapshot below it
                self.detailViewSnapShotImageView.alpha = 0

                //shrink both snapshots to cell size
                self.cellSnapShotImageView.frame = self.cellFrame!
                self.detailViewSnapShotImageView.frame = self.cellFrame!

                //update maps current content insets
                self.mapView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: self.collectionView.frame.height + 16, right: 16)
                self.zoomToLocation()
            })
        }
        return
    }


    private func panningChangedWithTranslation(recognizer: UIPanGestureRecognizer, translation: CGPoint) {

        if let animator = self.collapsableDetailsAnimator, animator.isRunning {
            return
        }

        print("Translation", translation)

        var progress: CGFloat


        if recognizer.view is UICollectionViewCell {

            // if user swiping up from cell to detailView (convert from negative number to positive)
            progress = -(translation.y / totalYMovement)
        } else {

            progress = (translation.y / totalYMovement)
        }

        progress = max(0.001, min(0.999, progress)) // ensure progress is a percentage (greather than 0, less than 1)
        collapsableDetailsAnimator?.fractionComplete = progress
    }



    private func panningEndedWithTranslation(recognizer: UIPanGestureRecognizer, translation: CGPoint, velocity: CGPoint) {

        recognizer.isEnabled = false

        //if user swiping up from cell to DetailView
        if let cell = recognizer.view as? UICollectionViewCell {

            // if animation progress is over 50% complete finish animation or swiped with high velocity
            if ( translation.y <= -totalYMovement / 2 || velocity.y <= -100) {

                self.collapsableDetailsAnimator!.addCompletion({ final in
                    recognizer.isEnabled = true

                    //remove the snapshots
                    self.detailViewSnapShotImageView.removeFromSuperview()
                    self.cellSnapShotImageView.removeFromSuperview()

                    //reveal the detailView
                    self.detailView!.isHidden = false
                })

            // else reverse animation
            } else {

                self.collapsableDetailsAnimator!.isReversed = true

                self.collapsableDetailsAnimator!.addCompletion({ final in
                    recognizer.isEnabled = true

                    //remove the snapshots
                    self.detailViewSnapShotImageView.removeFromSuperview()
                    self.cellSnapShotImageView.removeFromSuperview()

                    //remove detailView
                    if self.detailViewController != nil {
                        self.detailViewController!.removeFromParentViewController()
                        self.detailView!.removeFromSuperview()
                        self.detailViewController = nil
                        self.detailView = nil
                    }

                    //reset map content insets
                    self.mapView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: self.collectionView.frame.height + 16, right: 16)
                    self.zoomToLocation()
                })
            }
        //else if user swiping down from DetailView to cell
        } else {

            // if animation progress is over 50% complete finish animation or swiped with high velocity
            if (translation.y >= totalYMovement / 2 || velocity.y >= 100) {

                self.collapsableDetailsAnimator!.addCompletion({ final in
                    recognizer.isEnabled = true

                    if self.detailViewController != nil {

                        //remove the detailView
                        self.detailViewController!.removeFromParentViewController()
                        self.detailView!.removeFromSuperview()
                        self.detailViewController = nil
                        self.detailView = nil
                    }

                    //remove the snapShot views
                    self.detailViewSnapShotImageView.removeFromSuperview()
                    self.cellSnapShotImageView.removeFromSuperview()

                    //reload the collection view cells
                    self.collectionView.reloadData()

                    //increase cell scale after collectionView reload
                    self.collectionView.performBatchUpdates({}, completion: { (finished) in

                        self.animateCellsOnSwipe()
                    })

                })

            // else reverse animation
            } else {

                self.collapsableDetailsAnimator!.isReversed = true

                self.collapsableDetailsAnimator!.addCompletion({ final in
                    recognizer.isEnabled = true

                    if self.detailView != nil {
                        //reveal the detailView
                        self.detailView!.isHidden = false

                        //reset map content insets
                        self.mapView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: self.detailView!.frame.height + 16, right: 16)
                        self.zoomToLocation()

                        //remove the snapshots
                        self.detailViewSnapShotImageView.removeFromSuperview()
                        self.cellSnapShotImageView.removeFromSuperview()
                    }
                })
            }
        }


        let velocityVector = CGVector(dx: velocity.x / 100, dy: velocity.y / 100)
        let springParameters = UISpringTimingParameters.init(dampingRatio: 0.8, initialVelocity: velocityVector)

        collapsableDetailsAnimator?.continueAnimation(withTimingParameters: springParameters, durationFactor: 1.0)
    }
}

extension MainViewController: UIGestureRecognizerDelegate{

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        // if gestureRecogniser is a panGesture & it is attached to a collectionViewCell
        if let recognizer = gestureRecognizer as? UIPanGestureRecognizer {
            if recognizer.view is UICollectionViewCell {

                let translation = recognizer.translation(in: view)
                //only start the recogniser if the upward translation is greater than 1 (allows user to still scroll through collectionViewCells)
                if translation.y > -1 {
                    return false
                }

            } else if let detailVC = detailViewController, detailVC.keyboardVisibile {

                detailVC.dismissKeyboard()
                return false
            }
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

protocol ObjectiveTableViewControllerDelegate: class {
    func initiateSave()
}
