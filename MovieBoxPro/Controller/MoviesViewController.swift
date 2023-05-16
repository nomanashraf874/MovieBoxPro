//
//  MoviesViewController.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/4/23.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let searchController = UISearchController()
    let email = (UserDefaults.standard.value(forKey: "email") as? String)!
    var movies = [[String:Any]]()
    var originalMovies = [[String:Any]]()
    var movieApiManager = MovieApiManager()
    var userPreference: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        tableView.dataSource = self
        tableView.delegate = self
        movieApiManager.delegate=self
       // movieApiManager.getNowPlaying()
        DatabaseManager.base.getRecommendation(email: email)
        DatabaseManager.base.getPreferences(email: email) { res in
            self.movieApiManager.getMoviesByGenres(genres: res)
        }
        searchController.searchBar.delegate=self
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        let brandLightPurple = UIColor(named: "BrandLightPurple")!

        // Set the cancel button color
        searchController.searchBar.tintColor = brandLightPurple
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = brandLightPurple
            let icon = UIImage(systemName: "magnifyingglass")?.withTintColor(brandLightPurple, renderingMode: .alwaysOriginal)
            textField.leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            imageView.image = icon
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 16))
            paddingView.addSubview(imageView)
            textField.leftView = paddingView
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: brandLightPurple.withAlphaComponent(0.5),
                .font: UIFont.systemFont(ofSize: 14)
            ]
            textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)
        }
    }
// MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        print("Loading up the details screen")

        let cell = sender as! MovieCell
        let indexPath = tableView.indexPath(for:cell)!
        let movie = movies[indexPath.row]

        let detailsViewController = segue.destination as! MovieDetailsViewController
            detailsViewController.movie = movie

        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}
// MARK: -MovieApiManagerDelegate
extension MoviesViewController: MovieApiManagerDelegate{
    func load(_ movieApiManager: MovieApiManager, moviesDict: [[String:Any]]){
        self.movies=moviesDict
        self.originalMovies=moviesDict;
        self.tableView.reloadData()
    }
}
// MARK: -TableViewController
extension MoviesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let starCount = movie["vote_average"] as! Double
        let rd = movie["release_date"] as? String ?? "Incoming"
        
        //let synopsis = movie["overview"] as! String
        //let Xid = movie["id"]  as! String
        cell.titleLabel.text = title
        cell.starLabel.text="\(Double(round(10 * (starCount/2)) / 10))"
        cell.Date.text="Release Date: \(rd)"
        
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as? String ?? "/sg7klpt1xwK1IJirBI9EHaqQwJ5.jpg"
        let posterUrl = baseUrl + posterPath
        ImageDownloader.downloadImage(posterUrl) {
            image, urlString in
            if let imageObject = image {
                // performing UI operation on main thread
                DispatchQueue.main.async {
                    cell.posterView.image = imageObject
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MovieCell
        performSegue(withIdentifier: "RetToDet", sender: cell)
    }
}
// MARK: -SearchController
extension MoviesViewController:UISearchResultsUpdating,UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{
            return
        }
        movieApiManager.getSearchResult(query: text)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movies=originalMovies
        tableView.reloadData()
    }
    
}
