//
//  Movie.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 10/7/23.
//

import Foundation

class Movie {
    let genreIds: [String]
    let title: String
    let content: String
    let voteAverage: Double
    let releaseDate: String
    let posterPath: String
    let backdrop_path: String
    let overview: String
    let id: Int
    
    init(dictionary: [String: Any]) {
        self.genreIds = dictionary["genre_ids"] as? [String] ?? []
        self.title = dictionary["title"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.voteAverage = dictionary["vote_average"] as? Double ?? 0.0
        self.releaseDate = dictionary["release_date"] as? String ?? "Incoming"
        self.posterPath = dictionary["poster_path"] as? String ?? "/sg7klpt1xwK1IJirBI9EHaqQwJ5.jpg"
        self.backdrop_path = dictionary["backdrop_path"] as? String ?? ""
        self.overview = dictionary["overview"] as? String ?? ""
        self.id = dictionary["id"] as? Int ?? 0
    }
}
