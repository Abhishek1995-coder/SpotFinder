//
//  ContentView.swift
//  SpotFinder
//
//  Created by MAC on 06/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    @StateObject var registerVM = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showSuccessAlert = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Create Account")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack{
                TextField("Name", text: $registerVM.name)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(.gray.opacity(0.3))
                    .cornerRadius(14)
                TextField("Email", text: $registerVM.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(.gray.opacity(0.3))
                    .cornerRadius(14)
                SecureField("Password", text: $registerVM.password)
                    .padding()
                    .clipShape(Rectangle())
                    .background(.gray.opacity(0.3))
                    .cornerRadius(14)
                SecureField("Confirm Password", text: $registerVM.confirmPassword)
                    .padding()
                    .clipShape(Rectangle())
                    .background(.gray.opacity(0.3))
                    .cornerRadius(14)
                Toggle("Register as a admin", isOn: $registerVM.isChecked)
                    .padding()
            }
            // ERROR MESSAGE
            if !registerVM.error.isEmpty {
                Text(registerVM.error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
           
            Spacer()
            // SIGN UP BUTTON
            Button {
                registerVM.register()
            } label: {
                HStack {
                    if registerVM.isLoading {
                        ProgressView()
                    }else{
                        Text("Sign Up")
                            .bold()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(registerVM.isLoading)
            .onChange(of: registerVM.isRegistered) { oldValue, newValue in
                showSuccessAlert = newValue
            }
            .alert("Registration Successful",
                   isPresented: $showSuccessAlert,
                   actions: {
                       Button("OK") {
                           dismiss()
                       }
                   },
                   message: {
                       Text("Your account has been created.")
                   }
            )

            Spacer()
            HStack{
                Text("Already have an account ")
                    .font(.system(size: 14, weight: .regular))
                Text("Login ")
                    .font(.system(size: 16, weight: .semibold))
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        .padding(24)
    }
}

#Preview {
    ContentView()
}
