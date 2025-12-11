//
//  AdminViewModel.swift
//  SpotFinder
//
//  Created by Akash Verma on 10/12/25.
//

import FirebaseDatabase
import MapKit
import SwiftUI
import Foundation

struct Parking: Identifiable, Equatable{
    let id: String = UUID().uuidString
    var key: String
    var name: String
    var bikeCount: Int
    var carCount: Int
    var bikeBooking: Int
    var carBooking: Int
    var latitude: Double
    var longitude: Double
}

@Observable class AdminViewModel{
    var cameraPosition: MapCameraPosition = .automatic
    let ref = Database.database().reference()
    
    var parkings: [Parking] = []
    
    func registerParking(parking: Parking){
        let parkingDic = ["name": parking.name,
                          "bikeCount" : parking.bikeCount,
                          "carCount" : parking.carCount,
                          "bikeBooking" : parking.bikeBooking,
                          "carBooking" : parking.carBooking,
                          "latitude" : parking.latitude,
                          "longitude" : parking.longitude
        ] as [String : Any]
        
        ref.child("Parkings").childByAutoId().setValue(parkingDic) { error, _ in
            if let error = error {
                print("Error writing data: \(error)")
            }
        }
    }
    
    func updateParking(parking: Parking){
        let uniqueId = parking.key

        let updateData: [String: Any] = ["name": parking.name,
                                         "bikeCount" : parking.bikeCount,
                                         "carCount" : parking.carCount,
                                         "bikeBooking" : parking.bikeBooking,
                                         "carBooking" : parking.carBooking,
                                         "latitude" : parking.latitude,
                                         "longitude" : parking.longitude
        ]

        ref.child("Parkings").child(uniqueId).updateChildValues(updateData) { error, _ in
            if let error = error {
                print("Update error: \(error.localizedDescription)")
            } else {
                print("Updated successfully!")
            }
        }
    }
    

    
    func deleteParking(parking: Parking){
        let uniqueId = parking.key
        
        ref.child("Parkings").child(uniqueId).removeValue { error, _ in
            if let error = error {
                print("Error writing data: \(error)")
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
                    
                    }
            }
        }
    }
}
