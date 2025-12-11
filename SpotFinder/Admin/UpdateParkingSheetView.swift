//
//  AddParkingSheetView 2.swift
//  SpotFinder
//
//  Created by Akash Verma on 10/12/25.
//


import SwiftUI
import CoreLocation

struct AddParkingSheetView: View {
    @Binding var parking: Parking
    @State private var parkingName = ""
    
    var onCreate: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Create New Parking")
                .font(.headline)
                .padding(.top)

            VStack(alignment: .leading, spacing: 10) {
                TextField("Parking Name", text: $parking.name)
                    .textFieldStyle(.roundedBorder)
                
                counterRow(title: "Bike Slots", value: $parking.bikeCount)
                counterRow(title: "Car Slots", value: $parking.carCount)
                counterRow(title: "Bike Booked", value: $parking.bikeBooking)
                counterRow(title: "Car Booked", value: $parking.carBooking)
            }
            .padding(.horizontal)

            Spacer()

            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.gray.opacity(0.2))
                .cornerRadius(10)

                Button("Create") {
                    onCreate()
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
        func counterRow(title: String, value: Binding<Int>) -> some View {
            HStack {
                Text(title)
                Spacer()
                Button("-") { if value.wrappedValue > 0 { value.wrappedValue -= 1 } }
                    .padding(.horizontal, 12)
                    .font(.title2)

                Text("\(value.wrappedValue)")
                    .frame(width: 40)

                Button("+") { value.wrappedValue += 1 }
                    .padding(.horizontal, 12)
                    .font(.title2)
            }
            .padding(.horizontal)
        }
}
