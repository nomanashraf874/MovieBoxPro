//
//  MovieApiManager.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/4/23.
//

import Foundation

protocol MovieApiManagerDelegate{
    func load(_ movieApiManager: MovieApiManager, moviesDict: [[String:Any]])
}
struct MovieApiManager{
    let baseURL="https://api.themoviedb.org/3/movie/"
    let apiKey="?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var movies = [[String:Any]]()
    let email = (UserDefaults.standard.value(forKey: "email") as? String)!
    func getPopular(completionHandler: @escaping([[String: Any]])->Void) {
        let urlString="\(baseURL)popular\(apiKey)"
        performRequest(with: urlString){ res in
            completionHandler(res)
        }
    }
    
    func getLatest(completionHandler: @escaping([[String: Any]])->Void) {
        let urlString="\(baseURL)now_playing\(apiKey)"
        performRequest(with: urlString){ res in
            completionHandler(res)
        }
    }
    
    func getUpcoming(completionHandler: @escaping([[String: Any]])->Void) {
        let urlString="\(baseURL)upcoming\(apiKey)"
        performRequest(with: urlString){ res in
            completionHandler(res)
        }
    }
    
    func getRelated(id:Int, completionHandler: @escaping([[String: Any]])->Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        performRequest(with: urlString){ res in
            completionHandler(res)
        }
    }
    
    var delegate: MovieApiManagerDelegate?
    
    func getSearchResult(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://api.themoviedb.org/3/search/movie\(apiKey)&language=en-US&query=\(encodedQuery)"
        performSearch(with: urlString)
    }

    func performSearch(with urlString: String)
    {
        //print(urlString)
        let url = URL(string: urlString)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
                // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data
                let dict=dataDictionary["results"] as! [[String:Any]]
                delegate?.load(self, moviesDict: dict)
            }
        }
        task.resume()
        
    }
    
    func performRequest(with urlString: String,completionHandler: @escaping([[String: Any]])->Void)
    {
        print(urlString)
        let url = URL(string: urlString)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
                // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data
                let dict=dataDictionary["results"] as! [[String:Any]]
                completionHandler(dict)
            }
        }
        task.resume()
        
    }
    func getMoviesByGenres(genres: [String]) {
        var allMovies: [[String:Any]] = []
        var genreCombinations = [[String]]()
        for i in 0...(genres.count) {
            genreCombinations += genres.combinations(length: i)
        }
        genreCombinations.reverse()
        let group = DispatchGroup()
        for genreCombination in genreCombinations {
            let genreQueryString = genreCombination.joined(separator: "|")
            let urlString = "https://api.themoviedb.org/3/discover/movie\(apiKey)&sort_by=popularity.desc&with_genres=\(genreQueryString)"
            guard let url = URL(string: urlString) else {
                continue
            }
            group.enter()
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    group.leave()
                    return
                }
                guard let data = data else {
                    group.leave()
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let movieList = (json as? [String: Any])?["results"] as? [[String: Any]] {
                        for movie in movieList {
                            if allMovies.contains(where: { $0["title"] as! String == movie["title"] as! String }){
                                continue
                            } else{
                                allMovies.append(movie)
                            }
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
                group.leave()
            }
            task.resume()
        }
        
        group.notify(queue: DispatchQueue.main) {
            delegate?.load(self, moviesDict: allMovies)
        }
    }
    
    func getMovieID(id: String,completionHandler: @escaping(String)->Void){
        let baseUrl = "https://api.themoviedb.org/3/movie/"
        let api = "\(id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: baseUrl+api)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
                        // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let trailers = dataDictionary["results"] as! [[String:Any]]
                    let trailer = trailers[0]
                    let key = trailer["key"] as? String ?? ""
                    completionHandler(key)
                }
            }
            task.resume()
    }

}
extension Array {
    
    func combinations(length: Int) -> [[Element]] {
        if length == 0 {
            return [[]]
        }
        guard let first = self.first else {
            return []
        }
        let withoutFirst = Array(self.dropFirst())
        let combosWithoutFirst = withoutFirst.combinations(length: length)
        let combosWithFirst = withoutFirst.combinations(length: length - 1)
        return combosWithFirst.map { [first] + $0 } + combosWithoutFirst
    }
}
