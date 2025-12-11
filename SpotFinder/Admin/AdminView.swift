//
//  AdminView.swift
//  SpotFinder
//
//  Created by Akash Verma on 10/12/25.
//

import SwiftUI
import MapKit

struct AdminView: View {
    @State private var adminVM = AdminViewModel()
    @State private var tappedCoordinate: CLLocationCoordinate2D?
    @State private var createParking = Parking(key: "", name: "", bikeCount: 0, carCount: 0, bikeBooking: 0, carBooking: 0, latitude: 0, longitude: 0)
    @State private var showAddParkingSheet = false
    @State private var showUpdateParkingSheet = false
    @State private var updateParking = Parking(key: "", name: "", bikeCount: 0, carCount: 0, bikeBooking: 0, carBooking: 0, latitude: 0, longitude: 0)
    //@EnvironmentObject var loginVM: LoginViewModel

    var body: some View {
        MapReader { proxy in
            Map(position: $adminVM.cameraPosition) {
                
                UserAnnotation()
                
                ForEach(adminVM.parkings) { place in
                    Annotation(place.name, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)) {
                        ZStack {
                            Text(place.name)
                                .font(.caption2)
                                .padding(.horizontal, 2)
                                .padding(.top, 2)
                                .padding(.bottom, 6)
                                .background(
                                    Image(systemName: "bubble.middle.bottom.fill")
                                        .resizable()
                                        .font(.title)
                                        .foregroundStyle(Color.init(red: 7/255, green: 173/255, blue: 167/255))
                                        .onTapGesture {
                                            updateParking = place
                                            showUpdateParkingSheet = true
                                        }
)
                                .onTapGesture {
                                    updateParking = place
                                    showUpdateParkingSheet = true
                                }

                        }
                        .onTapGesture {
                            updateParking = place
                            showUpdateParkingSheet = true
                        }

                    }
                }
                
                if showAddParkingSheet{
                    Annotation("  ", coordinate: tappedCoordinate!) {
                        ZStack {
                            
                            Text(createParking.name == "" ? "Add Name" : createParking.name)
                                .font(.caption2)
                                .padding(.horizontal, 2)
                                .padding(.top, 2)
                                .padding(.bottom, 6)
                                .background(
                                    Image(systemName: "bubble.middle.bottom.fill")
                                        .resizable()
                                        .font(.title)
                                        .foregroundStyle(Color.red))
                        }
                    }
                }
            }
            .onTapGesture { location in
                if let coordinate = proxy.convert(location, from: .local) {
                    tappedCoordinate = coordinate
                    createParking.latitude = coordinate.latitude
                    createParking.longitude = coordinate.longitude
                    showAddParkingSheet = true
                    print("Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)")
                }
            }
            .sheet(isPresented: $showAddParkingSheet) {
                AddParkingSheetView(
                    parking: $createParking,
                    onCreate: {
                        adminVM.registerParking(parking: createParking)
                        showAddParkingSheet = false
                    },
                    onCancel: {
                        showAddParkingSheet = false
                    }
                )
                .presentationDetents([.height(300.0)])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showUpdateParkingSheet) {
                UpdateParkingSheetView(
                    parking: $updateParking,
                    onUpdate: {
                        adminVM.updateParking(parking: updateParking)
                        showUpdateParkingSheet = false
                    },
                    onDelete: {
                        adminVM.deleteParking(parking: updateParking)
                        showUpdateParkingSheet = false
                    }
                )
                .presentationDetents([.height(300.0)])
                .presentationDragIndicator(.visible)
            }
        }
        .ignoresSafeArea()

        .onAppear {
            adminVM.fetchParkings()
        }
        .ignoresSafeArea()
    }
}
