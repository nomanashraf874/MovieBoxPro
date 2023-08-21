//
//  UserProfileViewController.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/9/23.
//

import UIKit
import FirebaseAuth

class UserProfileViewController: UIViewController {
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, sender: Any?) -> Bool {
        return true
    }
    // MARK: Views
    
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet weak var wallpaperImageView: UIImageView!
    @IBOutlet weak var userInfoSectionView: UserProfileInfoSectionView!
    @IBOutlet weak var userActivityView: UIView!
    @IBOutlet weak var generesActivityViewSection: UIView!
    @IBOutlet weak var moviesActivityViewSection: UIView!
    @IBOutlet weak var commentsActivityViewSection: UIView!
    
    weak var generesActivitySectionVC: UserActivitySectionViewController!
    let myEmail = (UserDefaults.standard.value(forKey: "email") as? String)!
    var viewEmail:String = ""
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userInfoSectionView.setupViews(myEmail: myEmail, viewEmail: viewEmail)
        setUpUIViews(email:viewEmail == "" ? myEmail : viewEmail)
        if viewEmail != ""{
            signoutButton.isHidden=true
        }
        
    }
    
    // MARK: Actions
    @IBAction func signOutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Do you want to Sign Out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            do{
                try FirebaseAuth.Auth.auth().signOut()
                self.performSegue(withIdentifier: "logout", sender: self)
            }catch{
                print("Failed to log out")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert,animated: true)
    }
}



// MARK: - View configurations methods
extension UserProfileViewController {
    func setUpUIViews(email:String) {
        let needSpecificCornerRads = [generesActivityViewSection, commentsActivityViewSection]
        needSpecificCornerRads.forEach {
            $0?.clipsToBounds = true
            $0?.layer.cornerRadius = 14
        }
        generesActivityViewSection.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,]
        commentsActivityViewSection.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let needSmoothCorners = [userInfoSectionView, userActivityView, generesActivityViewSection, commentsActivityViewSection]
        needSmoothCorners.forEach { $0?.layer.cornerCurve = .continuous }
        
        // Sets Shadows
        let needShadow = [userInfoSectionView, userActivityView]
        needShadow.forEach {
            $0?.layer.shadowColor = UIColor.systemGray.cgColor
            $0?.layer.shouldRasterize = true
            $0?.layer.rasterizationScale = UIScreen.main.scale
        }
        
        // Initializes genere sections
        let generesActivitySectionVC = UserActivitySectionViewController(sectionType: .generes)
        generesActivitySectionVC.email=email
        addChild(generesActivitySectionVC)
        generesActivityViewSection.addSubview(generesActivitySectionVC.view)
        generesActivitySectionVC.view.frame = generesActivityViewSection.bounds
        
        // Initializes movie sections
        let movieActivitySectionVC = UserActivitySectionViewController(sectionType: .favoriteMovies)
        movieActivitySectionVC.email=email
        addChild(movieActivitySectionVC)
        moviesActivityViewSection.addSubview(movieActivitySectionVC.view)
        movieActivitySectionVC.view.frame = moviesActivityViewSection.bounds
        
        
        // Initializes comment sections
        let commentActivitySectionVC = UserActivitySectionViewController(sectionType: .userComments)
        commentActivitySectionVC.email=email
        addChild(commentActivitySectionVC)
        commentsActivityViewSection.addSubview(commentActivitySectionVC.view)
        commentActivitySectionVC.view.frame = commentsActivityViewSection.bounds

    }
}
