//
//  LocationViewController.swift
//  UserNotification Swift
//
//  Created by pro648 on 18/8/18
//  Copyright © 2018年 pro648. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class LocationViewController: UIViewController {
    
    var notificationType: UserNotificationType!
    
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var locValue: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    let locationManager = CLLocationManager()
    var coordinate2D = CLLocationCoordinate2D()
    var radius: Int = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Ask for authorisation from the user.
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        title = notificationType.title
        descriptionLabel.text = notificationType.descriptionText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                let alertController = UIAlertController(title: "Notification was disabled", message: "Turn on your notifications.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                alertController.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (action) in
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        radiusLabel.text = String(format: "%i", Int(sender.value))
        radius = Int(sender.value)
    }
    
    @IBAction func scheduleButtonTapped(_ sender: UIButton) {
        
        // content
        let content = UNMutableNotificationContent()
        content.title = "Location Notification"
        content.body = "Exit the specified region"
        
        // Creating a location-based trigger.
        let region = CLCircularRegion(center: coordinate2D, radius: CLLocationDistance(radius), identifier: "Headquarters")
        region.notifyOnExit = true
        region.notifyOnEntry = false
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        
        // identifier
        let identifier = notificationType.rawValue
        
        // request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // schedule
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to schedule location notification. error:\(error)")
            } else {
                print("Location notification scheduled:\(identifier)")
            }
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate2D = manager.location?.coordinate else{
            return
        }
        manager.stopUpdatingLocation()
        locValue.text = String(format: "Latitude:%f Longitude:%f", coordinate2D.latitude, coordinate2D.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get current location. error:\(error)")
    }
}
