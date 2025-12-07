//
//  LocationManager.swift
//  Map
//
//  Created by Akash Verma on 07/12/25.
//

import Combine
import CoreLocation

class LocationManagerNew: NSObject, CLLocationManagerDelegate, ObservableObject {
    static let shared = LocationManagerNew()
    
    private let manager = CLLocationManager()
    @Published var location: CLLocation?

    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}
