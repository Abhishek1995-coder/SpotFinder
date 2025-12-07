//
//  MapViewModel.swift
//  Map
//
//  Created by Akash Verma on 07/12/25.
//


import SwiftUI
import MapKit

@Observable class MapViewModel {
    var cameraPosition: MapCameraPosition = .automatic
    var route: MKRoute?
    var selectedPlace: Place?

    func getRoute(to destination: CLLocationCoordinate2D, from userLocation: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.route = route
                self.cameraPosition = .rect(route.polyline.boundingMapRect)
            }
        }
    }
}
