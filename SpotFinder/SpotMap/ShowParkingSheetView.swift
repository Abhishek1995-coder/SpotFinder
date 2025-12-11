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
    @Binding var arrBooking: [BookedParking]
    @State private var parkingName = ""
    
    var reserveCar: () -> Void
    @State var isDisableBikeBooking = false
    @State var isDisableCarBooking = false
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
                        isDisableCarBooking = true
                        setCarBookingUpdate()
                    }
                    .disabled(isDisableCarBooking)
                } else{
                    Text("No Car slot available")
                }
            }
            
            HStack {
                if parking.bikeCount > parking.bikeBooking{
                    Text("Available Bike Slots: \(parking.bikeCount - parking.bikeBooking)")
                    
                    Button("Reserve") {
                        reserveBike()
                        isDisableBikeBooking = true
                        setBikeBookingUpdate()
                    }
                    .disabled(isDisableBikeBooking)
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
        .onAppear {
            checkForReserver()
        }
    }
    
    private func checkForReserver(){
        if let index = arrBooking.firstIndex(where: { $0.key == parking.key }) {
            if arrBooking[index].bookingCar == true && arrBooking[index].carCount > 0{
                isDisableCarBooking = true
            }
            if  arrBooking[index].bookingBike == true && arrBooking[index].bikeCount > 0{
                isDisableBikeBooking = true
            }
        }
    }
    
    private func setCarBookingUpdate() {
        if let index = arrBooking.firstIndex(where: { $0.key == parking.key }) {
            arrBooking[index].bookingCar = true
        }
    }
    
    private func setBikeBookingUpdate() {
        if let index = arrBooking.firstIndex(where: { $0.key == parking.key }) {
            arrBooking[index].bookingBike = true
        }
    }
  
}
