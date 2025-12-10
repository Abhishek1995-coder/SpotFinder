struct AddParkingSheetView: View {
    var coordinate: CLLocationCoordinate2D

    @State private var parkingName = ""
    
    var onCreate: (String) -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Create New Parking")
                .font(.headline)
                .padding(.top)

            VStack(alignment: .leading, spacing: 10) {
                TextField("Parking Name", text: $parkingName)
                    .textFieldStyle(.roundedBorder)

                Text("Latitude: \(coordinate.latitude)")
                    .font(.caption)

                Text("Longitude: \(coordinate.longitude)")
                    .font(.caption)
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
                    onCreate(parkingName)
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
}
