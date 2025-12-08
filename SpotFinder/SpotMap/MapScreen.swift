//
//  MapScreen.swift
//  Map
//
//  Created by Akash Verma on 07/12/25.
//


import SwiftUI
import MapKit

struct MapScreen: View {
    @State private var viewModel = MapViewModel()
    @State private var userLocation: CLLocationCoordinate2D?

    let places = [
        Place(name: "Taj Mahal", coordinate: .init(latitude: 27.1751, longitude: 78.0421)),
        Place(name: "India Gate", coordinate: .init(latitude: 28.6129, longitude: 77.2295)),
        Place(name: "Qutub Minar", coordinate: .init(latitude: 28.5244, longitude: 77.1855))
    ]

    var body: some View {
        Map(position: $viewModel.cameraPosition) {

            UserAnnotation()

            ForEach(places) { place in
                Annotation(place.name, coordinate: place.coordinate) {
                    ZStack {
//                        Image(systemName: "bubble.middle.bottom.fill")
//                            .resizable()
//                            .font(.title)
//                            .foregroundStyle(Color.init(red: 7/255, green: 173/255, blue: 167/255))
//                            .frame(width: 60, height: 40, alignment: .center)
//                            .onTapGesture {
//                                viewModel.selectedPlace = place
//                                if let userLocation {
//                                    viewModel.getRoute(to: place.coordinate, from: userLocation)
//                                }
//                            }

                        Text(getDistanceText(place: place))
                            .font(.caption2)
                            .padding(.horizontal, 2)
                            .padding(.top, 2)
                            .padding(.bottom, 6)
                            .background(
                                Image(systemName: "bubble.middle.bottom.fill")
                                .resizable()
                                .font(.title)
                                .foregroundStyle(Color.init(red: 7/255, green: 173/255, blue: 167/255)))
                            .onTapGesture {
                                viewModel.selectedPlace = place
                                if let userLocation {
                                    viewModel.getRoute(to: place.coordinate, from: userLocation)
                                }
                            }
                    }
                }
            }

            if let route = viewModel.route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        .ignoresSafeArea()

        //.mapControls(.all)
        .onAppear {
            LocationManagerNew.shared.requestLocation()
        }
        /// Listen for live user location updates
        .onReceive(LocationManagerNew.shared.$location) { loc in
            userLocation = loc?.coordinate
        }
        .ignoresSafeArea()
    }
    
    func getDistanceText(place: Place) -> String {
        if let userLocation {
            let meters = userLocation.distance(from: place.coordinate)
            if meters >= 1000 {
                return String(format: "%.1f km", meters/1000)
            } else {
                return "\(Int(meters)) m"
            }
        }
        return "--"
    }
}


extension CLLocationCoordinate2D {
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let loc1 = CLLocation(latitude: latitude, longitude: longitude)
        let loc2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return loc1.distance(from: loc2) // distance in meters
    }
}
extension MKMapView{
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState,
                 fromOldState oldState: MKAnnotationView.DragState) {

        if newState == .ending {
            view.dragState = .none
            
            if let coord = view.annotation?.coordinate {
                print("Final Latitude: \(coord.latitude)")
                print("Final Longitude: \(coord.longitude)")
            }
        }
    }
}
