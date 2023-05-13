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
    var movie: [String:Any]!
    var commentViewController = CommentViewController()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the navigation bar to be transparent
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(movie)
        // Do any additional setup after loading the view.
        //DatabaseManager.base.addLike(with: email, movie: movie)
        SypnosisView.layer.cornerRadius = SypnosisView.frame.size.height / 5
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = baseUrl + posterPath
        ImageDownloader.downloadImage(posterUrl) {
            image, urlString in
            if let imageObject = image {
                // performing UI operation on main thread
                DispatchQueue.main.async {
                    self.posterView.image = imageObject
                }
            }
        }
        let id = movie["id"] as! Int
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = "https://image.tmdb.org/t/p/w780" + backdropPath
        ImageDownloader.downloadImage(backdropUrl) {
            image, urlString in
            if let imageObject = image {
                // performing UI operation on main thread
                DispatchQueue.main.async {
                    self.backdropView.image = imageObject
                }
            }
        }
        let relatedActivitySectionVC = UserActivitySectionViewController(sectionType: .related,id: id)
        addChild(relatedActivitySectionVC)
        RelatedView.addSubview(relatedActivitySectionVC.view)
        relatedActivitySectionVC.view.frame = RelatedView.bounds
        DatabaseManager.base.verifyLike(email: email, movie: movie) { res in
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "trailer"{
            let trailerViewController = segue.destination as! TrailerViewController
            trailerViewController.movieId = "\(movie["id"] as! Int)"
        }
        else{
//            let tid = movie["id"] as! Int
            let commentViewController = segue.destination as! CommentViewController
            commentViewController.movie=movie
        }
        print("Loading up the trailer")

        
    }

}
