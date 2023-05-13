//
//  GenreSectionCell.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/2/23.
//

import UIKit

enum MovieGenreType: String, CaseIterable {
    case action, adventure, animation, comedy, crime, documentary, drama, family, fantasy, history, horror, music, mystery, romance, scienceFiction, tvMovie, thriller, war, western
    /*
     action          28
     Adventure       12
     Animation       16
     Comedy          35
     Crime           80
     Documentary     99
     Drama           18
     Family          10751
     Fantasy         14
     History         36
     Horror          27
     Music           10402
     Mystery         9648
     Romance         10749
     Science Fiction 878
     TV Movie        10770
     Thriller        53
     War             10752
     Western         37
     */
    var index: Int {
        switch self {
        case .action:
            return 28
        case .adventure:
            return 12
        case .animation:
            return 16
        case .comedy:
            return 35
        case .crime:
            return 80
        case .documentary:
            return 99
        case .drama:
            return 18
        case .family:
            return 10751
        case .fantasy:
            return 14
        case .history:
            return 36
        case .horror:
            return 27
        case .music:
            return 10402
        case .mystery:
            return 9648
        case .romance:
            return 10749
        case .scienceFiction:
            return 878
        case .tvMovie:
            return 10770
        case .thriller:
            return 53
        case .war:
            return 10752
        case .western:
            return 37
        }
    }
}

class GenreSectionCell: UICollectionViewCell {
    @IBOutlet weak var genreImageView: UIImageView!
    @IBOutlet weak var genreTitleLabel: UILabel!
    @IBOutlet weak var chosenView: UIView!
    @IBOutlet weak var cornerImageView: UIImageView!
    
    var movieType: MovieGenreType!
    
    
    func configureWithData(_ movieType: MovieGenreType) {
        self.movieType = movieType
        genreImageView.image = UIImage(named: movieType.rawValue)
        genreTitleLabel.text = movieType.rawValue
        
        self.clipsToBounds = false
        self.contentView.clipsToBounds = false
        
        genreImageView.layer.shadowColor = UIColor.darkGray.cgColor
        genreImageView.layer.shadowOpacity = 0.5
        genreImageView.layer.shadowRadius = 2
        genreImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    
    func updateAppearence(isChosen: Bool) {
        
        if isChosen {
            
            chosenView.layer.cornerRadius = chosenView.bounds.height / 2
            chosenView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            chosenView.layer.borderColor = UIColor.systemGreen.cgColor
            chosenView.layer.borderWidth = 5
            chosenView.isHidden = false
            chosenView.layer.shadowColor = UIColor.darkGray.cgColor
            
            cornerImageView.layer.cornerRadius = cornerImageView.bounds.width / 2
            cornerImageView.isHidden = false
            
            genreImageView.transform = CGAffineTransform(scaleX: 0.68, y: 0.68)
            genreTitleLabel.font = .boldSystemFont(ofSize: 13)
            
        } else {
            chosenView.isHidden = true
            cornerImageView.isHidden = true
            chosenView.backgroundColor = .clear
            chosenView.layer.borderWidth = 0
            
            genreTitleLabel.font = .systemFont(ofSize: 12)
            genreImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
    }
    
}

