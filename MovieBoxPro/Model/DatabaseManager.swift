//
//  DatabaseManager.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 3/19/23.
//

import Foundation
 
import FirebaseFirestore
 
class DatabaseManager {
    
    static let base = DatabaseManager()
    private let db = Firestore.firestore()
    let genres = ["\(28)","\(12)","\(16)","\(35)","\(80)","\(99)","\(18)","\(10751)","\(14)","\(36)","\(27)","\(10402)","\(9648)","\(10749)","\(878)","\(10770)","\(53)","\(10752)","\(37)"]
    
    public func usernameToData(with user: User)
    {
        db.collection("Email").document(user.email).setData([
            "Username": user.username
        ])
        initializeUserGenres(with: user.email)
    }
    
    public func initializeUserGenres(with email: String){
        let prefRef = db.collection("Email").document(email).collection("UserPrefrences")
        for genre in genres{
            prefRef.document(genre).setData([
                "Likes": 0,
                "Comments": 0,
                "Initial": false,
            ])
            
        }
        let emailRef = db.collection("Email").document(email)
        emailRef.updateData([
            "Liked": [],
            "Commented": [],
            "Initialized": [],
            "Freinds":[],
            "Preferences":[],
            "TotalComments":0,
            "TotalLikes":0
        ])
    }
    
    func getName(email:String,completionHandler: @escaping((String)->Void)){
        let docRef = db.collection("Email").document(email)
        var ret = ""
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                ret=document.data()?["Username"] as? String ?? " "
                completionHandler(ret)
            } else {
                print("ERROR:\(error)")
            }
        }
    }
    
    public func addLike(email: String,movie:  [String : Any]){
        guard let genres = movie["genre_ids"] as? [Any] else{
            return
        }
        for genre in genres{
            let docRef=db.collection("Email").document(email).collection("UserPrefrences").document("\(genre)")
            docRef.updateData([
                "Likes": FieldValue.increment(Int64(1))
            ])
        }
        let doc = db.collection("Email").document(email)
        doc.updateData([
            "TotalLikes": FieldValue.increment(Int64(1))
        ])
        db.collection("Email").document(email).updateData([
            "Liked": FieldValue.arrayUnion([movie])
        ])
    }
    
    public func addComment(email: String,content:String, movie:  [String : Any], completionHandler: @escaping(Bool)->Void){
        guard let genres = movie["genre_ids"] as? [Any] else{
            return
        }
        for genre in genres{
            let docRef=db.collection("Email").document(email).collection("UserPrefrences").document("\(genre)")
            docRef.updateData([
                "Comments": FieldValue.increment(Int64(1))
            ])
        }
        let comment: [String: Any] = [
            "email":email,
            "content":content
            
        ]
        let docRef = db.collection("Comments").document(movie["title"] as! String)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.updateData([
                    "Comments": FieldValue.arrayUnion([comment])
                ])
            } else {
                let comments: [[String: Any]] = []
                docRef.setData([
                    "Comments":comments
                ])
                docRef.updateData([
                    "Comments": FieldValue.arrayUnion([comment])
                ])
            }
            completionHandler(true)
        }
        var movie = movie
        movie["content"]=content
        db.collection("Email").document(email).updateData([
            "Commented": FieldValue.arrayUnion([movie])
        ])
        let doc = db.collection("Email").document(email)
        doc.updateData([
            "TotalComments": FieldValue.increment(Int64(1))
        ])
    }
    
    public func addInitialize(with email: String,genres: [String]){
        for genre in genres{
            let docRef=db.collection("Email").document(email).collection("UserPrefrences").document(genre)
            docRef.updateData([
                "Initial": true
            ])
        }
        db.collection("Email").document(email).updateData([
            "Initialized": FieldValue.arrayUnion(genres),
            "Preferences": FieldValue.arrayUnion(genres)
        ])
    }
    
    public func verifyLike(email: String, movie: [String: Any], completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        let docRef = db.collection("Email").document(email)
        docRef.getDocument { (document, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let document = document else {
                completionHandler(.success(false))
                return
            }
            if let likedMovies = document.data()?["Liked"] as? [[String: Any]], likedMovies.contains(where: { dict in
                guard let title = dict["title"] as? String else {
                    return false
                }
                return title == movie["title"] as? String
            }) {
                completionHandler(.success(true))
            } else {
                completionHandler(.success(false))
            }
        }
    }
    
    public func verifyFollow(followerEmail: String, followingEmail: String, completionHandler: @escaping(Result<Bool, Error>)->Void) {
        let docRef = db.collection("Email").document(followerEmail)
        docRef.getDocument() { (document, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let document = document else {
                completionHandler(.success(false))
                return
            }
            if let following = document.data()?["Freinds"] as? [String], following.contains(followingEmail) {
                completionHandler(.success(true))
            } else {
                completionHandler(.success(false))
            }
        }
    }

    public func getComments(movie:String, completionHandler: @escaping(Result<[[String: Any]], Error>)->Void){
        var ret = [[String: Any]]()
        let docRef = db.collection("Comments").document(movie)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                ret = document.data()!["Comments"] as! [[String: Any]]
                completionHandler(.success(ret))
            } else if let error = error {
                completionHandler(.failure(error))
            }
            else{
                print("Unknown Error in getComments")
            }
        }
    }
    
    public func getLiked(email:String, completionHandler: @escaping(Result<[[String: Any]], Error>)->Void){
        var ret = [[String: Any]]()
        let docRef = db.collection("Email").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                ret = document.data()!["Liked"] as! [[String: Any]]
                completionHandler(.success(ret))
            } else if let error = error {
                completionHandler(.failure(error))
            }
            else{
                print("Unknown Error in getLiked")
            }
        }
    }
    
    public func getCommented(email:String, completionHandler: @escaping(Result<[[String: Any]], Error>)->Void){
        var ret = [[String: Any]]()
        let docRef = db.collection("Email").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                ret = document.data()!["Commented"] as! [[String: Any]]
                completionHandler(.success(ret))
            } else if let error = error {
                completionHandler(.failure(error))
            }
            else{
                print("Unknown Error in getCommented")
            }
        }
    }
    
    public func addFreind(email: String, otherEmail:String){
        let docRef = db.collection("Email").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.updateData([
                    "Freinds": FieldValue.arrayUnion([otherEmail])
                ])
            } else if let error = error {
                print("Error:\(error)")
            }
            else{
                print("Unknown Error in addFreind")
            }
        }
    }
    
    public func getProfile(email: String, completionHandler: @escaping(([String],Int,Int))->Void){
        let docRef = db.collection("Email").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let ret = document.data()!["Freinds"] as! [String]
                let totalComments = document.data()?["TotalComments"] as? Int ?? 0
                let totalLikes = document.data()?["TotalLikes"] as? Int ?? 0
                completionHandler((ret,totalComments,totalLikes))
            } else if let error = error {
                print("Error:\(error)")
            }
            else{
                print("Unknown Error in getProfile")
            }
        }
    }
    
    public func getInitialized(email: String, completionHandler: @escaping(Result<[String], Error>)->Void){
        var ret = [String]()
        let docRef = db.collection("Email").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                ret = document.data()!["Initialized"] as! [String]
                completionHandler(.success(ret))
            } else if let error = error {
                print("Error:\(error)")
            }
            else{
                print("Unknown Error in getInitialized")
            }
        }
    }
    
    public func getPreferences(email: String, completion: @escaping([String])->Void){
        let docRef = db.collection("Email").document(email)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let preferences = document.data()?["Preferences"] as? [String] ?? []
                    completion(preferences)
                } else if let error = error {
                    completion([])
                    print("Error:\(error)")
                }
                else{
                    print("Unknown Error in getPreferences")
                }
            }
    }
    
    public func getUserPreferences(email: String, completion: @escaping([String: [String: Any]])->Void){
        let docRef = db.collection("Email").document(email).collection("UserPrefrences")
        docRef.getDocuments { querySnapshot, error in
            if let error = error {
                    print("Error getting documents: \(error)")
            } else {
                var userPrefs: [String:[String: Any]] = [:]
                for document in querySnapshot!.documents {
                    let documentID = document.documentID
                    userPrefs[documentID]=document.data()
                }
                completion(userPrefs)
            }
        }
    }
    
    public func getRecommendation(email: String){
        var freindPreferences: [String:Int] = [:]
        let group = DispatchGroup()
        for genre in genres {
            freindPreferences[genre] = 0
        }
        getProfile(email: email) { (freinds,totalComments,totalLikes) in
            for freind in freinds{
                group.enter()
                self.getPreferences(email: freind) { freindPreference in
                    for preference in freindPreference {
                        freindPreferences[preference]!+=1
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.getUserPreferences(email: email) { userPreferences in
                    var pref : [String:Double] = [:]
                    for genre in self.genres{
                        let initialized = userPreferences[genre]!["Initial"] as! Bool == true ? 0.25 : 0
                        let freindsPref = (Double(freindPreferences[genre]!) / Double(freinds.count == 0 ? 1:freinds.count))*0.25
                        let likePref = (Double(userPreferences[genre]!["Likes"] as! Int) / Double(totalLikes == 0 ? 1:totalLikes )) * 0.25
                        let commentPref = (Double(userPreferences[genre]!["Comments"] as! Int) / Double(totalComments == 0 ? 1:totalComments)) * 0.25
                        let score = initialized + freindsPref + likePref + commentPref
                        pref[genre] = score
                    }
                    let top3Keys = pref.sorted { $0.value > $1.value }
                        .prefix(4)
                        .map { $0.key }

                    self.db.collection("Email").document(email).updateData([
                        "Preferences": top3Keys
                    ])
                }
            }
            
        }
        
    }
    
}



