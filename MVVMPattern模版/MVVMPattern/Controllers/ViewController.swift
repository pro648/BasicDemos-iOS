//
//  ViewController.swift
//  MVVMPattern
//
//  Created by pro648 on 2019/7/9.
//  Copyright © 2019 pro648. All rights reserved.
//

import MapKit
import YelpAPI

class ViewController: UIViewController {

    // MARK: - Properties
    private var businesses: [YLPBusiness] = []
    private let client = YLPClient(apiKey: YelpAPIKey)
    private let locationManager = CLLocationManager()
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMap(on: userLocation.coordinate)
    }
    
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 3500
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        searchForBusiness()
    }
    
    private func searchForBusiness() {
        let coordinate = mapView.userLocation.coordinate
        guard coordinate.latitude != 0 && coordinate.longitude != 0 else {
            return
        }
        
        let yelpCoordinate = YLPCoordinate(latitude: coordinate.latitude,
                                           longitude: coordinate.longitude)
        
        client.search(with: yelpCoordinate,
                      term: "coffee",
                      limit: 35,
                      offset: 0,
                      sort: .bestMatched) { [weak self](searchResult, error) in
                        guard let strongSelf = self else { return }
                        
                        guard let searchResult = searchResult,
                            error == nil else {
                                print("Search failed: \(String(describing: error))")
                                return
                        }
                        
                        strongSelf.businesses = searchResult.businesses
                        DispatchQueue.main.async {
                            strongSelf.addAnnotations()
                        }
        }
    }
    
    private func addAnnotations() {
        for business in businesses {
            guard let yelpCoordinate = business.location.coordinate else {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: yelpCoordinate.latitude,
                                                    longitude: yelpCoordinate.longitude)
            let name = business.name
            let rating = business.rating
            let annotation = MapPin(coordinate: coordinate,
                                    name: name,
                                    rating: rating)
            mapView.addAnnotation(annotation)
        }
    }
}

