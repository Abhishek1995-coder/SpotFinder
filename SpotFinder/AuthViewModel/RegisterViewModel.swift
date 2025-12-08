//
//  RegisterViewModel.swift
//  SpotFinder
//
//  Created by MAC on 07/12/25.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

@MainActor
class RegisterViewModel: ObservableObject {
    
    @Published var email:String = ""
    @Published var name:String = ""
    @Published var password:String = ""
    @Published var confirmPassword:String = ""
    @Published var error:String = ""
    @Published var isLoading:Bool = false
    @Published var isRegistered:Bool = false
    @Published var isChecked = false
    private var cancellables = Set<AnyCancellable>()
    let ref = Database.database().reference()
    
    init(){
        $email
            .sink {[weak self] value in
                print("value", value)
                self?.error = ""
            }
            .store(in: &cancellables)
        $password
            .sink {[weak self] value in
                print("password", value)
                self?.error = ""
            }
            .store(in: &cancellables)
        $confirmPassword
            .sink {[weak self] value in
                print("password", value)
                self?.error = ""
            }
            .store(in: &cancellables)
    }
    
    func isEmailValid()->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isVaidPassword()->Bool{
        if password == "" || password.count < 6{
            error = "Password must be at least 6 characters"
            return false
        }
        return true
    }
    
    func isConfirmPassword()->Bool{
        if password != confirmPassword{
            error = "Confirm Password should match with Password"
            return false
        }
        return true
    }
  
    func register(){
        if !isEmailValid(){
            error = "Please enter valid email"
            return
        }
        if !isVaidPassword(){
            return
        }
        if !isConfirmPassword(){
            return
        }
        
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self](authResult, error) in
                self?.isLoading = false
                if let error = error{
                    self?.error = error.localizedDescription
                    self?.isRegistered = false
                }else{
                    self?.isRegistered = true
                    self?.registerUser()
                }
        }
    }
    
    func registerUser(){
        ref.child("Users").childByAutoId().setValue(["email": email,"name":name,"isAdmin":isChecked]) { error, _ in
            if let error = error {
                print("Error writing data: \(error)")
            } 
        }
    }
}
