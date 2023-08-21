//
//  GenresSurveyViewController.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/2/23.
//

import UIKit

class GenresSurveyViewController: UIViewController, GenreSectionManager {
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var genreSectionViewContainer: UIView!
    let genreSectionVC = UserActivitySectionViewController(sectionType: .generes)
    let email = (UserDefaults.standard.value(forKey: "email") as? String)!
    let allGenres = MovieGenreType.allCases
    var chosenGenres = Set<MovieGenreType>() {
        didSet {
            genresCollectionView.reloadData()
            updateContinueButtonState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    @IBAction func continueButton(_ sender: Any) {
        var arr: [String] = []
        for genre in chosenGenres{
            arr.append("\(genre.index)")
        }
        DatabaseManager.base.addInitialize(with: email, genres: arr)
        self.performSegue(withIdentifier: "SurToLog", sender: self)
    }

}
// MARK: - UICollectionView Delegate / DataSource
extension GenresSurveyViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieGenreType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreSectionCell", for: indexPath) as! GenreSectionCell
        
        cell.configureWithData(allGenres[indexPath.row])
        if chosenGenres.contains(cell.movieType) {
            cell.updateAppearence(isChosen: true)
        } else {
            cell.updateAppearence(isChosen: false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GenreSectionCell
        if chosenGenres.contains(allGenres[indexPath.row]) {
            chosenGenres.remove(allGenres[indexPath.row])
            removeGenre(allGenres[indexPath.row])
        } else {
            chosenGenres.update(with: cell.movieType)
            addGenre(cell.movieType)
            scrollGenreSection(to: .right)
        }
    }
    
    
    
}


// MARK: - View configurations methods
extension GenresSurveyViewController {
    
    func setupViews() {
        footerView.backgroundColor = UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)
        footerView.layer.shadowColor = UIColor(red: 0.05, green: 0.08, blue: 0.11, alpha: 1.0).cgColor
        footerView.layer.shadowOpacity = 0.5
        footerView.layer.shadowOffset = CGSize(width: 0, height: -3)
        footerView.layer.shadowRadius = 3
        footerView.layer.cornerCurve = .continuous
        
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self

        let nibCell = UINib(nibName: "GenreSectionCell", bundle: .main)
        genresCollectionView.register(nibCell, forCellWithReuseIdentifier: "GenreSectionCell")

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(
            width: (genresCollectionView.bounds.width + 20 + 8) / 4,
            height: (genresCollectionView.bounds.width + 20 + 8) / 4)

        genresCollectionView.collectionViewLayout = layout

        genreSectionVC.view.layer.cornerRadius = 18
        genreSectionViewContainer.addSubview(genreSectionVC.view)
        genreSectionVC.view.frame = genreSectionViewContainer.bounds
        genreSectionVC.sectionTitleLabel.text = "Pick at least 3 genres"
        genreSectionVC.sectionSeeAllLabel.isHidden = false
        genreSectionVC.sectionSeeAllLabel.text = "total: \(chosenGenres.count)"
        
    }
    
    func updateContinueButtonState() {
        if chosenGenres.count < 3 {
            continueButton.isEnabled = false
        } else {
            continueButton.isEnabled = true
        }
    }
}

