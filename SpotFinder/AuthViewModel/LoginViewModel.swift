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

struct UserModel: Identifiable {
    var id: String            // Firebase Key
    var email: String
    var isAdmin: Bool
    var name: String?
    var parkingKey: String
}

@MainActor
class LoginViewModel:ObservableObject{
    
    @Published var emailLogin:String = "ghtf@gmail.com" //"akash.viet007@gmail.com"
    @Published var password:String = "12345678" //"abc123"
    @Published var name:String = ""
    @Published var error:String = ""
    @Published var isLoading:Bool = false
    @Published var isLoginSuccess = false
    @Published var islocationupdate = false
    @Published var myUser: UserModel?
    
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
                self?.getMyUser()
                //self?.fetchUsers()
            }
        }
    }
    
    func getMyUser(){
        ref.child("Users")
            .queryOrdered(byChild: "email")
            .queryEqual(toValue: emailLogin)
            .observeSingleEvent(of: .value) { snapshot in
                
                for child in snapshot.children {
                    if let snap = child as? DataSnapshot,
                       let dict = snap.value as? [String: Any] {
                        
                        self.myUser = UserModel(
                            id: snap.key,
                            email: dict["email"] as? String ?? "",
                            isAdmin: dict["isAdmin"] as? Bool ?? false,
                            name: dict["name"] as? String,
                            parkingKey: dict["parkingKey"] as? String ?? ""
                        )
                    }
                }
            }
    }
    
    func fetchUsers() {
        ref.child("Users").observe(.value) { snapshot in
            //var temp: [UserModel] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any] {
                    
                    let email = value["email"] as? String ?? ""
                    let isAdmin = value["isAdmin"] as? Bool ?? false
                    let name = value["name"] as? String ?? ""
                    let parkingKey = value["parkingKey"] as? String ?? ""
//                    temp.append(UserModel(id: snap.key,
//                                          email: email,
//                                          isAdmin: isAdmin,
//                                          name: name))
                    self.myUser = UserModel(id: snap.key,
                                            email: email,
                                            isAdmin: isAdmin,
                                            name: name,
                                            parkingKey: parkingKey)
                    if email.lowercased() == email.lowercased(){
                        
                    }
                }
            }
            //                DispatchQueue.main.async {
            //                    self.users = temp
            //                }
        }
    }
}
