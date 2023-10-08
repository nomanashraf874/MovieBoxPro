//
//  UserActivitySectionViewController.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/3/23.
//

import UIKit
import CoreData

enum UserActivitySectionType: CaseIterable {
    case generes, favoriteMovies, userComments, popular, latest, upcoming, related
    
    var cellId: String {
        switch self {
        case .generes: return "GenreSectionCell"
        case .favoriteMovies: return "MovieSectionCell"
        case .userComments: return "CommentSectionCell"
        case .popular: return "MovieSectionCell"
        case .latest: return "MovieSectionCell"
        case .upcoming: return "MovieSectionCell"
        case .related: return "MovieSectionCell"
        }
    }
}
class UserActivitySectionViewController: UIViewController {
    
    // MARK: Views
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionSeeAllLabel: UILabel!
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    var email = (UserDefaults.standard.value(forKey: "email") as? String)!
    var movieApiManager = MovieApiManager()
    // MARK: Data
    private let sectionType: UserActivitySectionType
    private let id: Int?
    var movieSeg:[Movie] = []
    var genreData: [MovieGenreType] = [
    
    ] {
        didSet { sectionCollectionView.reloadData()}
    }
    
    private var movieData: [Movie] = [
    ]{
        didSet { sectionCollectionView.reloadData()}
    }
    private var relatedData: [Movie] = [
    ]{
        didSet { sectionCollectionView.reloadData()}
    }
    private var commentData: [commentType] = [
    ]{
        didSet { sectionCollectionView.reloadData()}
    }
    convenience init() {
        self.init(sectionType: .popular)
    }
    // MARK: Initialization
    init(sectionType: UserActivitySectionType) {
        self.sectionType = sectionType
        self.id = nil
        super.init(nibName: "UserActivitySectionViewController", bundle: Bundle.main)
    }
    
    init(sectionType: UserActivitySectionType, id: Int) {
        self.sectionType = sectionType
        self.id = id
        super.init(nibName: "UserActivitySectionViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        setupViews()
        setUpDBViews()
    }
    
    // MARK: Actions
    @objc func seeAllLabelTapped(_ sender: UITapGestureRecognizer) {
        switch sectionType {
        case .generes:
            print("see all button tapped on section \(sectionType)")
        case .favoriteMovies:
            print("see all button tapped on section \(sectionType)")
        case .userComments:
            print("see all button tapped on section \(sectionType)")
        case .popular:
            print("see all button tapped on section \(sectionType)")
        case .latest:
            print("see all button tapped on section \(sectionType)")
        case .upcoming:
            print("see all button tapped on section \(sectionType)")
        case .related:
            print("see all button tapped on section \(sectionType)")
        }
        
        
        
        
    }
    func setUpDBViews() {
        switch sectionType {
        case .generes:
            DatabaseManager.base.getInitialized(email: email) { result in
                switch result{
                case .success(let genres):
                    for genre in genres{
                        self.genreData.append(MovieGenreType(rawValue: self.GenreValue(genre))!)
                    }
                case .failure(let err):
                    print("ERROR: \(err)")
                    
                }
            }
        case .favoriteMovies:
            DatabaseManager.base.getLiked(email: email) { result in
                switch result{
                case .success(let movies):
                    self.movieSeg=movies
                    for movie in movies{
                        self.movieData.append(movie)
                    }

                case .failure(let err):
                    print("ERROR: \(err)")

                }
            }
        case .userComments:
            DatabaseManager.base.getCommented(email: email) { result in
                switch result{
                case .success(let comments):
                    for comment in comments{
                        let content = comment.content
                        let title=comment.title
                        self.commentData.append(commentType(content: content, movieName: title))
                    }
                case .failure(let err):
                    print("ERROR: \(err)")
                }
            }
        case .popular:
            movieApiManager.getPopular(){ moviesDict in
                self.movieSeg=moviesDict
                self.movieData.append(contentsOf: moviesDict)
            }
        case .latest:
            movieApiManager.getLatest(){ moviesDict in
                self.movieSeg=moviesDict
                self.movieData.append(contentsOf: moviesDict)
            }
        case .upcoming:
            movieApiManager.getUpcoming(){ moviesDict in
                self.movieSeg=moviesDict
                self.movieData.append(contentsOf: moviesDict)
            }
        case .related:
            movieApiManager.getRelated(id: id!){ moviesDict in
                self.movieSeg=moviesDict
                self.movieData.append(contentsOf: moviesDict)
            }
        }
        
        
    }
    func GenreValue(_ value:String)->String{
        switch value{
        case "28":
            return "action"
        case "12":
            return "adventure"
        case "16":
            return "animation"
        case "35":
            return "comedy"
        case "80":
            return "crime"
        case "99":
            return "documentary"
        case "18":
            return "drama"
        case "10751":
            return "family"
        case "14":
            return "fantasy"
        case "36":
            return "history"
        case "27":
            return "horror"
        case "10402":
            return "music"
        case "9648":
            return "mystery"
        case "10749":
            return "romance"
        case "878":
            return "scienceFiction"
        case "10770":
            return "tvMovie"
        case "37":
            return "western"
        case "53":
            return "thriller"
        case "10752":
            return "war"
        default:
            return "action"
        }
    }
    
    
}

// MARK: - UICollectionView Delegate / DataSource / DelegateFlowLayout
extension UserActivitySectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionHeight = sectionCollectionView.bounds.height
        switch sectionType {
        case .generes:
            return CGSize(width: collectionHeight + 3,
                          height: collectionHeight)
        case .favoriteMovies:
            return CGSize(width: ((collectionHeight / 3) * 2) - 20,
                          height: collectionHeight)
        case .userComments:
            return CGSize(width: collectionHeight * 2,
                          height: collectionHeight)
        case .popular:
            return CGSize(width: ((collectionHeight / 3) * 2) - 20,
                          height: collectionHeight)
        case .latest:
            return CGSize(width: ((collectionHeight / 3) * 2) - 20,
                          height: collectionHeight)
        case .upcoming:
            return CGSize(width: ((collectionHeight / 3) * 2) - 20,
                          height: collectionHeight)
        case .related:
            return CGSize(width: ((collectionHeight / 3) * 2) - 20,
                          height: collectionHeight)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sectionType {
        case .generes:
            return genreData.count
        case .favoriteMovies:
            return movieData.count
        case .userComments:
            return commentData.count
        case .popular:
            return movieData.count
        case .latest:
            return movieData.count
        case .upcoming:
            return movieData.count
        case .related:
            return movieData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sectionType {
        case .generes:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionType.cellId, for: indexPath) as! GenreSectionCell
            cell.configureWithData(genreData[indexPath.row])
            return cell
        case .favoriteMovies:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionType.cellId, for: indexPath) as! MovieSectionCell
            cell.configureWithData(movieData[indexPath.row])
            return cell
        case .userComments:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionType.cellId, for: indexPath) as! CommentSectionCell
            cell.configureWithData(commentData[indexPath.row])
            return cell
        case .popular:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionType.cellId, for: indexPath) as! MovieSectionCell
            cell.configureWithData(movieData[indexPath.row])
            return cell
        case .latest:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionType.cellId, for: indexPath) as! MovieSectionCell
            cell.configureWithData(movieData[indexPath.row])
            return cell
        case .upcoming:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionType.cellId, for: indexPath) as! MovieSectionCell
            cell.configureWithData(movieData[indexPath.row])
            return cell
        case .related:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionType.cellId, for: indexPath) as! MovieSectionCell
            cell.configureWithData(movieData[indexPath.row])
            return cell
        
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sectionType {
        case .generes:
            print("genres item at index \(indexPath.row) has been selected")
        case .userComments:
            print("userComments item at index \(indexPath.row) has been selected")
        default:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            detailVC.movie = movieSeg[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
            //present(detailVC, animated: false)
        }
        
    }
    
}
// MARK: - View configurations methods
extension UserActivitySectionViewController {
    func setupViews() {
        // Registers cell
        UserActivitySectionType.allCases.forEach {
            if sectionType == $0 {
                let userActivitySectionCollectionViewCell = UINib(nibName: $0.cellId, bundle: nil)
                sectionCollectionView.register(userActivitySectionCollectionViewCell, forCellWithReuseIdentifier: $0.cellId)
            }
        }
        
        sectionCollectionView.delegate = self
        sectionCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        switch sectionType {
        case .generes:
            sectionTitleLabel.text = "Generes"
            layout.minimumLineSpacing = 0
            sectionSeeAllLabel.isHidden = true
        case .favoriteMovies:
            sectionTitleLabel.text = "Favorite Movies"
            layout.minimumLineSpacing = 10
        case .userComments:
            sectionTitleLabel.text = "Comments"
            layout.minimumLineSpacing = 5
        case .popular:
            sectionTitleLabel.text = "Popular"
            sectionTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            layout.minimumLineSpacing = 10
        case .latest:
            sectionTitleLabel.text = "Now Playing"
            sectionTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            layout.minimumLineSpacing = 10
        case .upcoming:
            sectionTitleLabel.text = "Upcoming"
            sectionTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            layout.minimumLineSpacing = 10
        case .related:
            sectionTitleLabel.text = "Related"
            sectionTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            layout.minimumLineSpacing = 10
            
        }
        sectionCollectionView.collectionViewLayout = layout
        
        // Enables touches on label "see all"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (seeAllLabelTapped))
        sectionSeeAllLabel.isUserInteractionEnabled = true
        sectionSeeAllLabel.addGestureRecognizer(tapGesture)
    }
    
}


// MARK: - GenreSectionManager Protocol / Extension
protocol GenreSectionManager {
    var genreSectionVC: UserActivitySectionViewController { get }
}
extension GenreSectionManager {
    func addGenre(_ data: MovieGenreType) {
        genreSectionVC.genreData.append(data)
        genreSectionVC.sectionSeeAllLabel.text = "total: \(genreSectionVC.genreData.count)"
    }
    func removeGenre(_ data: MovieGenreType) {
        guard let index = genreSectionVC.genreData.firstIndex(where: { $0 == data }) else { return }
        genreSectionVC.genreData.remove(at: index)
        genreSectionVC.sectionSeeAllLabel.text = "total: \(genreSectionVC.genreData.count)"
    }
    func scrollGenreSection(to bound: UICollectionView.ScrollPosition) {
        genreSectionVC.sectionCollectionView.scrollToItem(at: IndexPath(row: genreSectionVC.genreData.count - 1, section: 0), at: bound, animated: true)
    }
    
}
