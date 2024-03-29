//
//  MovieDetailsViewController.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/11/23.
//

import UIKit

class MovieDetailsViewController: UIViewController{
    
    
    @IBOutlet var RelatedView: UIView!
   
    @IBOutlet var selectedSegment: UISegmentedControl!
    @IBOutlet var CommentView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet var SypnosisView: UIView!
    let email = (UserDefaults.standard.value(forKey: "email") as? String)!
    @IBOutlet var backdropView: UIImageView!
    @IBOutlet var posterView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var synopsisLabel: UILabel!
    var movie: Movie!
    var commentViewController = CommentViewController()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleLabel()
        setupSynopsisLabel()
        setupPosterImage()
        setupBackdropImage()
        setupRelatedSection()
        setupLikeButton()
        setupSegmentedView()
    }
    
    func setupTitleLabel(){
        titleLabel.text = movie.title
        titleLabel.sizeToFit()
    }
    
    func setupSynopsisLabel(){
        SypnosisView.layer.cornerRadius = SypnosisView.frame.size.height / 5
        synopsisLabel.text = movie.overview
        synopsisLabel.sizeToFit()
    }
    
    func setupPosterImage(){
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie.posterPath
        let posterUrl = baseUrl + posterPath
        ImageDownloader.downloadImage(posterUrl) {
            image, urlString in
            if let imageObject = image {
                DispatchQueue.main.async {
                    self.posterView.image = imageObject
                }
            }
        }
    }
    
    func setupBackdropImage(){
        let id = movie.id
        let backdropPath = movie.backdrop_path
        let backdropUrl = "https://image.tmdb.org/t/p/w780" + backdropPath
        ImageDownloader.downloadImage(backdropUrl) {
            image, urlString in
            if let imageObject = image {
                DispatchQueue.main.async {
                    self.backdropView.image = imageObject
                }
            }
        }
    }
    
    func setupRelatedSection(){
        let id = movie.id
        let relatedActivitySectionVC = UserActivitySectionViewController(sectionType: .related,id: id)
        addChild(relatedActivitySectionVC)
        RelatedView.addSubview(relatedActivitySectionVC.view)
        relatedActivitySectionVC.view.frame = RelatedView.bounds
    }
    
    func setupLikeButton(){
        DatabaseManager.base.verifyLike(email: email, movieName: movie.title) { res in
            switch res{
            case .success(let ans):
                if ans{
                    self.likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                    self.likeButton.isUserInteractionEnabled = false
                }else{
                    print("Not Liked Yet")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupSegmentedView(){
        let brandLightPurple = UIColor(named: "BrandLightPurple")!
        let brandPurple = UIColor(named: "BrandPurple")!
        selectedSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: brandLightPurple], for: .normal)
        selectedSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: brandPurple], for: .selected)
    }
    
    @IBAction func selectcontainer(_ sender: Any) {
        if selectedSegment.selectedSegmentIndex==0{
            RelatedView.isHidden=false
            CommentView.isHidden=true
        }
        else{
            RelatedView.isHidden=true
            CommentView.isHidden=false
        }
    }
    
    @IBAction func trailerButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "trailer", sender: self)
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        DatabaseManager.base.addLike(email: email, movie: movie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trailer"{
            let trailerViewController = segue.destination as! TrailerViewController
            trailerViewController.movieId = "\(movie.id)"
        }
        else{
            let commentViewController = segue.destination as! CommentViewController
            commentViewController.movie=movie
        }
    }

}
