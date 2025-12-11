//
//  ShowParkingSheetView.swift
//  SpotFinder
//
//  Created by Akash Verma on 10/12/25.
//
import SwiftUI

struct ShowParkingSheetView: View {
    var parking: Parking
    var distance: String
    @State private var parkingName = ""
    
    var reserveCar: () -> Void
    var reserveBike: () -> Void
    var onGetDirection: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(parking.name)
                .font(.headline)
                .padding(.top)
            
            HStack{
                Text("Distance from you: ")
                Text(distance)
            }
            
            HStack {
                if parking.carCount > parking.carBooking{
                    Text("Available Car Slots: \(parking.carCount - parking.carBooking)")
                    
                    Button("Reserve") {
                        reserveCar()
                    }
                } else{
                    Text("No Car slot available")
                }
            }
            
            HStack {
                if parking.bikeCount > parking.bikeBooking{
                    Text("Available Bike Slots: \(parking.bikeCount - parking.bikeBooking)")
                    
                    Button("Reserve") {
                        reserveBike()
                    }
                } else{
                    Text("No Bike slot available")
                }
            }
            
            Button("Get Direction"){
                onGetDirection()
            }
            .padding(5)
            .padding(.horizontal, 5)
            .background(
                Capsule()
                    .fill(Color.init(red: 7/255, green: 157/255, blue: 167/255))
            )
            .foregroundColor(.white)
        }
    }
}
