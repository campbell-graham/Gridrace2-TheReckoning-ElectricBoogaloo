//
//  DetailViewController.swift
//  GridRace
//
//  Created by Christian on 2/26/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var objectives = [Objective]()
    let objective: Objective
    private let mapView = MKMapView()
    private let clearView = UIView()
    private var zoomToUser = false

    //user location
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    private var updatingLocation = false
    private var lastLocationError: Error?

    private let detailViewController: DetailViewController
    private lazy var collapsableDetailsView: UIView = {

        let view = detailViewController.view
        return view ?? UIView()
    }()

    var delegate: ObjectiveTableViewControllerDelegate? {
        didSet {
            detailViewController.delegate = self.delegate
        }
    }
    private var isCollapsed = false
    private var collapsableDetailsAnimator: UIViewPropertyAnimator?

    init(objective: Objective, data: ObjectiveUserData) {

        self.objective = objective
        self.objectives = AppResources.ObjectiveData.sharedObjectives.objectives

        self.detailViewController = DetailViewController( objective: objective, data: data )
        super.init(nibName: nil, bundle: nil)

        addChildViewController(detailViewController)
        detailViewController.didMove(toParentViewController: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {

        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
        title = objective.name

        setUpLayout()

        //set up animation panGestureRecognizer
        let collapseGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(collapseAnimationHandler))
        detailViewController.panView.addGestureRecognizer(collapseGestureRecogniser)

        clearView.backgroundColor = UIColor.clear

        // show user, and zoom to objective location
        //mapView.showsUserLocation = true

        //addCircles()
        //getUserLocation()
        //showLocations()
    }

    private func setUpLayout() {

        for view in [ clearView, collapsableDetailsView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            clearView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            clearView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            clearView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            clearView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            collapsableDetailsView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.6),
            collapsableDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collapsableDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collapsableDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc func getUserLocation() {
        //ask permission for user location  (also had to add "NSLocationWhenInUseUsageDescription" to Info.plist file)
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        // if permission denied show popup alert
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        //start/stop searching for user location
        if updatingLocation {
            stopLocationManager()
        } else {
            userLocation = nil
            lastLocationError = nil
            startLocationManager()
        }
    }

    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }

    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }

    func addCircles() {
        for objective in objectives {
            if let objCord = objective.coordinate {

                addPreciseCircle(coordinate: objCord)
                addRandomCircle(coordinate: objCord, radius: 150.0)
            }
        }
    }

    func showLocations() {

        // set region to userLocation to begin with
        var region = MKCoordinateRegionMakeWithDistance( mapView.userLocation.coordinate, 1000, 1000)

        // if there only one location, set region to that location
        if let objCord = objective.coordinate {

            region = MKCoordinateRegionMakeWithDistance( objCord, 1000, 1000)


        } else {
            self.zoomToUser = true
        }

        // if there are many location set region to fit them all
        /*else {

            var topLeft = CLLocationCoordinate2D(latitude: -90,  longitude: 180)
            var bottomRight = CLLocationCoordinate2D(latitude: 90, longitude: -180)

            for objective in objectives {
                if let objCord = objective.coordinate {
                    topLeft.latitude = max(topLeft.latitude,  objCord.latitude)
                    topLeft.longitude = min(topLeft.longitude,  objCord.longitude)
                    bottomRight.latitude = min(bottomRight.latitude, objCord.latitude)
                    bottomRight.longitude = max(bottomRight.longitude, objCord.longitude)
                }
            }

            let center = CLLocationCoordinate2D(
                latitude: topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2,
                longitude: topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2)
            let extraSpace = 1.1
            let span = MKCoordinateSpan( latitudeDelta: abs(topLeft.latitude - bottomRight.latitude) * extraSpace,
                                         longitudeDelta: abs(topLeft.longitude - bottomRight.longitude) * extraSpace)
            region = MKCoordinateRegion(center: center, span: span)

        }*/

        mapView.setRegion(region, animated: true)
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        //print("didUpdateLocations \(newLocation)")
        // only update location if its been at least 5 seconds from last update
        guard newLocation.timestamp.timeIntervalSinceNow > -5 else { return }
        // filter out invalid location updates
        guard newLocation.horizontalAccuracy > 0 else { return }


        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = userLocation {
            distance = newLocation.distance(from: location)
        }

        // only update if current location hasnt been retrieved or the new update is more accurate
        if userLocation == nil || userLocation!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            userLocation = newLocation
            if zoomToUser {
                zoomTo(location: userLocation!)
                zoomToUser = false
            }
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
            }
        }
        else if distance < 1 {
            let timeInterval = newLocation.timestamp.timeIntervalSince(userLocation!.timestamp)
            if timeInterval > 10 {
                print("*** Force done!")
                stopLocationManager()
            }
        }
    }

    func zoomTo(location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance( location.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }

    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        present(alert, animated: true, completion: nil)
        alert.addAction(okAction)
    }


    func addPreciseCircle(coordinate: CLLocationCoordinate2D){
        self.mapView.delegate = self
        let circle = MKCircle(center: coordinate, radius: 10 as CLLocationDistance)
        self.mapView.add(circle)
    }

    func addRandomCircle(coordinate: CLLocationCoordinate2D, radius: Double){
        self.mapView.delegate = self

        // generate a random offset in meters that is within the radius (so that the objective location will fall in new circle)
        let randOffset = coordinate.latitude + (randBetween(lower: 20, upper: Int(radius - 10) ) as CLLocationDistance)

        // use offset to create a new random center for the overlay circle
        let randCenter = locationWithBearing(bearing: randOffset, distanceMeters: randOffset, origin: coordinate)

        let circle = MKCircle(center: randCenter, radius: radius as CLLocationDistance)
        self.mapView.add(circle)
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

    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = #colorLiteral(red: 0.002938413294, green: 0.002939529018, blue: 0.002938266611, alpha: 1)
            circle.fillColor = #colorLiteral(red: 0.002938413294, green: 0.002939529018, blue: 0.002938266611, alpha: 0.4145440925)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }

    //Mark- pan animation code

    // the value between the animated views highest possible point and lowest possible point of detailView
    private var totalYMovement: CGFloat = 0.0

    @objc private func collapseAnimationHandler(recognizer: UIPanGestureRecognizer) {

        // translation is a numeric value that represents how much pixels the user has moved from start of panning
        let translation = recognizer.translation(in: view)


        if recognizer.state == .began {

            // on start of user panning, set destination frame of the animated viewController
            onPanBegin()
        }

        if recognizer.state == .ended {

            let velocity = recognizer.velocity(in: view)
            // whilst the user is panning translate their finger position the progress of the panning animaition of collapsableView
            panningEndedWithTranslation(recognizer: recognizer, translation: translation, velocity: velocity)

        }

        else {
            // when the user stops panning, decide where the collapsible view should bounce back to
            panningChangedWithTranslation(translation: translation)
        }
    }

    private func onPanBegin() {

        if let animator = collapsableDetailsAnimator, animator.isRunning {
            return
        }

        var targetFrame: CGRect
        let oldFrame = collapsableDetailsView.frame

        if !isCollapsed {

            let newY = view.bounds.height - detailViewController.panView.bounds.height - 128

            targetFrame = CGRect(x: oldFrame.minX, y: newY, width: oldFrame.size.width, height: oldFrame.size.height)

            totalYMovement = targetFrame.origin.y - oldFrame.origin.y
        } else {

            let newY = UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.bounds.height + mapView.bounds.height - collapsableDetailsView.bounds.height + 1
            targetFrame = CGRect(x: oldFrame.minX, y: newY, width: oldFrame.width, height: oldFrame.height)

            totalYMovement =  oldFrame.origin.y - targetFrame.origin.y
        }

        collapsableDetailsAnimator = UIViewPropertyAnimator(duration: 0.6, curve: .easeIn,
        animations: {
            self.collapsableDetailsView.frame = targetFrame
        })

        return
    }


    private func panningChangedWithTranslation(translation: CGPoint) {

        if let animator = self.collapsableDetailsAnimator, animator.isRunning {
            return
        }

        print("Translation", translation)

        var progress: CGFloat
        if self.isCollapsed {
            progress = -(translation.y / totalYMovement)
        } else {
            progress = (translation.y / totalYMovement)
        }

        progress = max(0.001, min(0.999, progress)) // ensure progress is a percentage (greather than 0, less than 1)

        collapsableDetailsAnimator?.fractionComplete = progress
    }



    private func panningEndedWithTranslation(recognizer: UIPanGestureRecognizer, translation: CGPoint, velocity: CGPoint) {

        recognizer.isEnabled = false

        let screenHeight = UIScreen.main.bounds.height

        if isCollapsed {
            if (translation.y <= -screenHeight / 3 || velocity.y <= -100)
            {
                self.collapsableDetailsAnimator!.isReversed = false

                self.collapsableDetailsAnimator!.addCompletion({ final in

                    self.isCollapsed = false
                    recognizer.isEnabled = true
                })
            } else {
                self.collapsableDetailsAnimator!.isReversed = true

                self.collapsableDetailsAnimator!.addCompletion({ final in
                    self.isCollapsed = true
                    recognizer.isEnabled = true
                })
            }
        } else {

            if (translation.y >= screenHeight / 3 || velocity.y >= 100) {

                self.collapsableDetailsAnimator!.isReversed = false

                self.collapsableDetailsAnimator!.addCompletion({ final in
                    self.isCollapsed = true
                    recognizer.isEnabled = true
                })
            } else {
                self.collapsableDetailsAnimator!.isReversed = true

                self.collapsableDetailsAnimator!.addCompletion({ final in

                    self.isCollapsed = false
                    recognizer.isEnabled = true
                })
            }
        }

        let velocityVector = CGVector(dx: velocity.x / 100, dy: velocity.y / 100)
        let springParameters = UISpringTimingParameters.init(dampingRatio: 0.8, initialVelocity: velocityVector)

        collapsableDetailsAnimator?.continueAnimation(withTimingParameters: springParameters, durationFactor: 1.0)
    }
}

