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
//                self.databaseTests()
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
                //self.databaseTests()
            }
        }
    }
    func databaseTests(){
        let email = "testc@gmail.com"
//        let genres = ["28","12","16"]
//        let movie:[String:Any]=["genre_ids":genres,"title":"Rocky"]
//        DatabaseManager.base.addLike(email: email, movie: movie)
//        DatabaseManager.base.addComment(email: email, content: "Testing", movie: movie)
//        DatabaseManager.base.addFreind(email: email, otherEmail: "Testing@gmail.com")
//        DatabaseManager.base.addInitialize(with: email, genres: genres)
////        DatabaseManager.base.getFreinds(email: email) { result in
////            switch result{
////            case .success(let res):
////                print(res)
////            case .failure(let err):
////                print(err)
////            }
////        }
//        DatabaseManager.base.getCommented(email: email) { result in
//            switch result{
//            case .success(let res):
//                print(res)
//            case .failure(let err):
//                print(err)
//            }
//        }
//        DatabaseManager.base.getLiked(email: email) { result in
//            switch result{
//            case .success(let res):
//                print(res)
//            case .failure(let err):
//                print(err)
//            }
//        }
//        DatabaseManager.base.getInitialized(email: email) { result in
//            switch result{
//            case .success(let res):
//                print(res)
//            case .failure(let err):
//                print(err)
//            }
//        }
//        DatabaseManager.base.getComments(movie: movie["title"] as! String) { result in
//            switch result{
//            case .success(let res):
//                print(res)
//            case .failure(let err):
//                print(err)
//            }
//        }
//        DatabaseManager.base.getPreferences(email: email) { res in
//            print("preferences: \(res)")
//        }
//        DatabaseManager.base.getUserPreferences(email: email) { ret in
//            print(ret)
//        }
        DatabaseManager.base.getRecommendation(email: email)
    }
}
