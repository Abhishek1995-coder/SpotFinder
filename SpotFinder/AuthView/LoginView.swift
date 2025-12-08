//
//  LoginView.swift
//  SpotFinder
//
//  Created by MAC on 07/12/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginVM = LoginViewModel()
    @State private var showingSheet = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        if loginVM.isLoginSuccess{
            VStack{
                ZStack(alignment: .trailing){
                    Text("SpotFinder")
                        .frame(maxWidth: .infinity)
                    Text("\(loginVM.name.uppercased().first ?? "J")")
                        .padding(8)
                        .background(Circle().fill(.gray).opacity(0.3))
                        .padding(.trailing, 10)
                        .onTapGesture {
                            showLogoutAlert = true
                        }
                }
                .alert("Are you sure you want to Logout?", isPresented: $showLogoutAlert, actions: {
                    Button("OK") {
                        loginVM.isLoginSuccess = false
                    }
                    
                    Button("Cancel") {
                        showLogoutAlert = false
                    }
                })
                .frame(maxWidth: .infinity)
                MapScreen()
            }
        } else{
            VStack(spacing: 24) {
                Text("Login ")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack{
                    TextField("Name", text: $loginVM.name)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .padding()
                        .background(.gray.opacity(0.3))
                        .cornerRadius(14)
                    
                    TextField("Email", text: $loginVM.emailLogin)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .padding()
                        .background(.gray.opacity(0.3))
                        .cornerRadius(14)
                    
                    // PASSWORD
                    SecureField("Password", text: $loginVM.password)
                        .padding()
                        .clipShape(Rectangle())
                        .background(.gray.opacity(0.3))
                        .cornerRadius(14)
                }
                .padding(.top,30)
                
                // ERROR MESSAGE
                if !loginVM.error.isEmpty {
                    Text(loginVM.error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                
                Button {
                    loginVM.login()
                } label: {
                    HStack {
                        if loginVM.isLoading {
                            ProgressView()
                        }else{
                            Text("Login")
                                .bold()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(loginVM.isLoading)
                Spacer()
                HStack{
                    Text("Don't have an account ")
                        .font(.system(size: 14, weight: .regular))
                    Text("Signup ")
                        .font(.system(size: 16, weight: .semibold))
                        .onTapGesture {
                            showingSheet = true
                        }
                        .fullScreenCover(isPresented: $showingSheet) {
                            ContentView()
                        }
                }
            }
            .padding(24)
        }
    }
    
    // MARK: - VALIDATION + ACTION
    func handleSignUp() {
        
    }
}

#Preview {
    LoginView()
}
