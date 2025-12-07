//
//  Place.swift
//  Map
//
//  Created by Akash Verma on 07/12/25.
//


import MapKit

struct Place: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}
