//
//  LoginViewModel.swift
//  SpotFinder
//
//  Created by MAC on 07/12/25.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

@MainActor
class LoginViewModel:ObservableObject{
    
    @Published var emailLogin:String = "akash.viet007@gmail.com"
    @Published var password:String = "abc123"
    @Published var name:String = ""
    @Published var error:String = ""
    @Published var isLoading:Bool = false
    @Published var isLoginSuccess = false
    @Published var islocationupdate = false
    private var cancellables = Set<AnyCancellable>()
    let ref = Database.database().reference()
   
    func isEmailValid()->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailLogin)
    }
    
    func isVaidPassword()->Bool{
        if password == "" || password.count < 6{
            error = "Password must be at least 6 characters"
            return false
        }
        return true
    }
  
    func login(){
        if !isEmailValid(){
            error = "Please enter valid email"
            return
        }
        if !isVaidPassword(){
            return
        }
        
        isLoading = true
        Auth.auth().signIn(withEmail: emailLogin, password: password) {[weak self] (authResult, error) in
                self?.isLoading = false
            if let error = error{
                self?.error = error.localizedDescription
            }else{
                print("User login")
                self?.isLoginSuccess = true
            }
        }
    }
    
}
