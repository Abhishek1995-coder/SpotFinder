//
//  AddParkingSheetView 2.swift
//  SpotFinder
//
//  Created by Akash Verma on 10/12/25.
//


import SwiftUI
import CoreLocation

struct UpdateParkingSheetView: View {
    @Binding var parking: Parking
    @State private var parkingName = ""
    
    var onUpdate: () -> Void
    var onDelete: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Create New Parking")
                .font(.headline)
                .padding(.top)

            VStack(alignment: .leading, spacing: 10) {
                TextField("Parking Name", text: $parking.name)
                    .textFieldStyle(.roundedBorder)
                
                counterRow(title: "Bike Slots", value: $parking.bikeCount, maxCount: 500)
                counterRow(title: "Car Slots", value: $parking.carCount, maxCount: 500)
                counterRow(title: "Bikes Booked", value: $parking.bikeBooking, maxCount: parking.bikeCount)
                counterRow(title: "Car Booked", value: $parking.carBooking, maxCount: parking.carCount)
            }
            .padding(.horizontal)
            .onChange(of: parking) {
                if parking.bikeBooking > parking.bikeCount{
                    parking.bikeBooking = parking.bikeCount
                }
                
                if parking.carBooking > parking.carCount{
                    parking.carBooking = parking.carCount
                }
            }

            Spacer()

            HStack {
                Button("Delete") {
                    onDelete()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.gray.opacity(0.2))
                .cornerRadius(10)

                Button("Okay") {
                    onUpdate()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    @ViewBuilder
    func counterRow(title: String, value: Binding<Int>, maxCount: Int) -> some View {
        HStack {
            Text(title)
            Spacer()
            Button("-") { if value.wrappedValue > 0 { value.wrappedValue -= 1 } }
                .padding(.horizontal, 12)
                .font(.title2)
                .disabled(value.wrappedValue == 0)
            
            Text("\(value.wrappedValue)")
                .frame(width: 40)
            
            Button("+") {
                if value.wrappedValue < maxCount {
                    value.wrappedValue += 1
                }
            }
            .padding(.horizontal, 12)
            .font(.title2)
            .disabled(value.wrappedValue == maxCount)
        }
        .padding(.horizontal)
    }
}
