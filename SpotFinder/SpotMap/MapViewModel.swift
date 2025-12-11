//
//  MapViewModel.swift
//  Map
//
//  Created by Akash Verma on 07/12/25.
//


import FirebaseDatabase
import MapKit
import SwiftUI

struct BookedParking{
    var key : String
    var bookingCar:Bool
    var bookingBike:Bool
    var carCount:Int
    var bikeCount:Int
}



@Observable class MapViewModel {
    var cameraPosition: MapCameraPosition = .automatic
    var route: MKRoute?
    var selectedParking: Parking?
    var arrayBookParking = [BookedParking]()
    
    
    let ref = Database.database().reference()
    var parkings: [Parking] = []

    func getRoute(from userLocation: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: selectedParking!.latitude, longitude: selectedParking!.longitude)))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.route = route
                self.cameraPosition = .rect(route.polyline.boundingMapRect)
            }
        }
    }
    
    func bikeParkingBooked(parking: Parking){
        let uniqueId = parking.key
        let bikeBooking = parking.bikeBooking
        let updateData: [String: Any] = ["bikeBooking" : bikeBooking + 1]
        ref.child("Parkings").child(uniqueId).updateChildValues(updateData) { error, _ in
            if let error = error {
                print("Update error: \(error.localizedDescription)")
            } else {
                print("Updated successfully!")
            }
        }
    }
    
    func carParkingBooked(parking: Parking){
        let uniqueId = parking.key
        let carBooking = parking.carBooking
        let updateData: [String: Any] = ["carBooking" : carBooking + 1]

        ref.child("Parkings").child(uniqueId).updateChildValues(updateData) { error, _ in
            if let error = error {
                print("Update error: \(error.localizedDescription)")
            } else {
                print("Updated successfully!")
            }
        }
    }
    
    
    func fetchParkings() {
        ref.child("Parkings").observe(.value) { snapshot in
            self.parkings.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any] {
                    
                    let name = value["name"] as? String ?? ""
                    let bikeCount = value["bikeCount"] as? Int ?? 0
                    let carCount = value["carCount"] as? Int ?? 0
                    let bikeBooking = value["bikeBooking"] as? Int ?? 0
                    let carBooking = value["carBooking"] as? Int ?? 0
                    let latitude = value["latitude"] as? Double ?? 0
                    let longitude = value["longitude"] as? Double ?? 0
                    
                    self.parkings.append(Parking(key: snap.key, name: name, bikeCount: bikeCount, carCount: carCount, bikeBooking: bikeBooking, carBooking: carBooking, latitude: latitude, longitude: longitude))
                    self.arrayBookParking.append(BookedParking(key: snap.key, bookingCar: false, bookingBike: false,carCount: carCount,bikeCount: bikeCount))
                    }
            }
        }
    }
}
