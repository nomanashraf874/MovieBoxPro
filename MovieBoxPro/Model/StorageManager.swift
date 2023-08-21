//
//  StorageManager.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 3/19/23.
//

import Foundation
import FirebaseStorage


class StorageMangager {
    static let base = StorageMangager()
    
    private let storage = Storage.storage().reference()
    
    public func storePicture(with data: Data, fileName: String, completionHandler: @escaping(String) -> Void){
        storage.child("profileImages/\(fileName)").putData(data, metadata: nil, completion: {metadata,error in
            if let e = error {
                print("putDataERROR\(e)")
            }else{
                self.storage.child("profileImages/\(fileName)").downloadURL(completion: { url, error in
                    if let e = error {
                        print("downloadURLERROR\(e)")
                    }else{
                        let urlString = url?.absoluteString
                        completionHandler(urlString!)
                    }
                })
            }
        })
    }
    
    public func getURL(for path: String, completionHandler: @escaping (URL) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL(completion: { url, error in
            if let e = error {
                print("downloadURLERROR\(e)")
            }else{
                completionHandler(url!)
            }
        })
    }
    
    
}

