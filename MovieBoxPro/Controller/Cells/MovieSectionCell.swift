//
//  MovieSectionCell.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/9/23.
//

import UIKit

class MovieSectionCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    func configureWithData(_ movieViewModel: MovieViewModel) {
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterUrl = baseUrl + movieViewModel.ImageURL
        ImageDownloader.downloadImage(posterUrl) {
            image, urlString in
            if let imageObject = image {
                // performing UI operation on main thread
                DispatchQueue.main.async {
                    self.movieImageView.image = imageObject
                }
            }
        }
        movieTitleLabel.text = movieViewModel.title
    }
    
}
