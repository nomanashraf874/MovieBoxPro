//
//  UserProfileInfoSectionView.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/9/23.
//

import UIKit

class UserProfileInfoSectionView: UIView {
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userLikedMoviesCountLabel: UILabel!
    @IBOutlet weak var userFollowingCountLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    var myEmail = ""
    var viewEmail = ""
    var email = (UserDefaults.standard.value(forKey: "email") as? String)!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    func commonInit() {
        let contentView = Bundle.main.loadNibNamed("UserProfileInfoSectionView", owner: self)?.first as! UIView
        contentView.frame = self.bounds
        contentView.backgroundColor = .clear
        addSubview(contentView)
    }
    
    func setupViews(myEmail: String,viewEmail: String) {
        print("IN")
        userPhotoImageView.layer.masksToBounds = true
        self.myEmail=myEmail
        self.viewEmail=viewEmail
        if viewEmail==myEmail || viewEmail == "" {
            followButton.isEnabled=false
            print("IN 1")
        }
        else{
            email = viewEmail
            DatabaseManager.base.verifyFollow(followerEmail: myEmail, followingEmail: viewEmail) { result in
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let res):
                    if res{
                        self.followButton.setTitle("Following", for: .normal)
                        self.followButton.isEnabled=false
                        print("IN 2")
                    } else{
                        print("Not Following")
                    }
                }
            }
        }
        userPhotoImageView.makeRoundWithBorder(
            borderWidth: 3.0,
            borderColor: userNameLabel.textColor.cgColor)
        profilePictureHeader()
        DatabaseManager.base.getFreinds(email: email) { (freinds,totalComments,totalLikes) in
            self.userLikedMoviesCountLabel.text="\(totalLikes)"
            self.userFollowingCountLabel.text="\(freinds.count)"
        }
        DatabaseManager.base.getName(email: email) { ret in
            self.userNameLabel.text=ret
        }
        userNicknameLabel.text=email
        
        
        
    }
    func profilePictureHeader() {
        let imageFile = email+"_profilePicture.png"
        let path = "profileImages/"+imageFile
        StorageMangager.base.getURL(for: path) { url in
            ImageDownloader.downloadImage("\(url)") {
                image, urlString in
                if let imageObject = image {
                    // performing UI operation on main thread
                    DispatchQueue.main.async {
                        self.userPhotoImageView.image = imageObject
                    }
                }
            }
        }
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.6, animations: {
            self.followButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }, completion: { _ in
                UIView.animate(withDuration: 0.6) {
                    self.followButton.transform = CGAffineTransform.identity
                }
        })
        self.followButton.setTitle("Following", for: .normal)
        followButton.isEnabled=false
        DatabaseManager.base.addFreind(email: myEmail, otherEmail: viewEmail)
    }
    
}

extension UIImageView {
    func makeRoundWithBorder(borderWidth: CGFloat, borderColor: CGColor) {
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
}
