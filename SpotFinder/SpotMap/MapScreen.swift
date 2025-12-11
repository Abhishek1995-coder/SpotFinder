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
    @State private var showParkingSheet = false

    var body: some View {
        VStack(alignment: .leading){
            Text("Find Parking")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
            Text("Nearby available spots")
                .font(.subheadline)
                .padding(.horizontal)
            Map(position: $viewModel.cameraPosition) {
                
                UserAnnotation()
                
                ForEach(viewModel.parkings) { place in
                    Annotation(place.name, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)) {
                        ZStack {
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
                                    viewModel.selectedParking = place
                                    showParkingSheet = true
//                                    if let userLocation {
//                                        viewModel.getRoute(from: userLocation)
//                                    }
                                }
                        }
                    }
                }
                
                if let route = viewModel.route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 5)
                }
            }
            .sheet(isPresented: $showParkingSheet) {
                ShowParkingSheetView(
                    parking: viewModel.selectedParking!,
                    distance: getDistanceText(place: viewModel.selectedParking!),
                    reserveCar: {
                        // increment count in Parking & save
                        // save parking key & type as car in preference
                    },
                    reserveBike: {
                        
                    },
                    onGetDirection: {
                        if let userLocation {
                            viewModel.getRoute(from: userLocation)
                        }
                        
                        showParkingSheet = false
                        viewModel.selectedParking = nil
                    }
                )
                .presentationDetents([.height(200.0)])
                .presentationDragIndicator(.visible)
            }
        }
        .ignoresSafeArea()

        .onAppear {
            LocationManagerNew.shared.requestLocation()
            viewModel.fetchParkings()
        }
        /// Listen for live user location updates
        .onReceive(LocationManagerNew.shared.$location) { loc in
            userLocation = loc?.coordinate
        }
        .ignoresSafeArea()
    }
    
    func getDistanceText(place: Parking) -> String {
        if let userLocation {
            let meters = userLocation.distance(from: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
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
