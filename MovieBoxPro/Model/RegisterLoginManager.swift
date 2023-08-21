//
//  RegisterManager.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 3/19/23.
//

import FirebaseAuth
import UIKit

class RegisterLoginManager{
    static let base = RegisterLoginManager()
    func register(username: String,email: String, password:String,image: UIImage,completionHandler: @escaping(Result<Bool, NSError>)->Void ){
        UserDefaults.standard.set(email, forKey: "email")
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error  {
                let err = error as NSError
                completionHandler(.failure(err))
                return
            } else{
                let currUser=User(username: username, email: email)
                DatabaseManager.base.usernameToData(with: currUser)
                if let data = image.pngData(){
                    let imageFile = "\(currUser.email)_profilePicture.png"
                    StorageMangager.base.storePicture(with: data, fileName: imageFile) { url in
                        UserDefaults.standard.set(url, forKey: "profilePicture")
                    }
                }
                completionHandler(.success(true))
            }
        }
    }
    func login(email: String, password:String, completionHandler: @escaping(Result<Bool, NSError>)->Void ){
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let err = error as NSError
                completionHandler(.failure(err))
                return
            } else{
                UserDefaults.standard.set(email, forKey: "email")
                completionHandler(.success(true))
            }
        }
    }
}
