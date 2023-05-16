//
//  CommentViewController.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/24/23.
//

import UIKit
import CoreData
class CommentViewController: UITableViewController {

    
    @IBOutlet var commentTableView: UITableView!
    let email = (UserDefaults.standard.value(forKey: "email") as? String)!
    var movie : [String:Any] = [:]
    var imageCache = NSCache<NSString, UIImage>()
    @IBOutlet var commentTextField: UITextField!
    var comments = [[String:Any]]()
    //var delegate:SegueHandler?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Define a variable to keep track of the original frame of the view
    var originalFrame: CGRect?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        commentTextField.delegate=self
        loadComments()
        
        // Add an observer for keyboard will show/hide notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        commentTextField.attributedPlaceholder = NSAttributedString(string: "Comment", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "BrandLightPurple")?.withAlphaComponent(0.5) ?? UIColor.gray])

    }
    func loadComments() {
        DatabaseManager.base.getComments(movie: movie["title"] as! String) { result in
            switch result {
            case .success(let res):
                DispatchQueue.global(qos: .background).async {
                    let reversedComments = res.reversed()
                    DispatchQueue.main.async {
                        self.comments = Array(reversedComments)
                        self.commentTableView.reloadData()
                    }
                }
            case .failure(let err):
                self.comments = []
                print(err)
            }
        }
    }
    

    func saveComment(){
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    // Move the view up when the keyboard appears
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }

        if originalFrame == nil {
            originalFrame = view.frame
        }

        let keyboardHeight = keyboardFrame.height
        let offsetY = commentTextField.frame.maxY - 33 - view.safeAreaInsets.bottom
        let delta = max(offsetY + keyboardHeight - originalFrame!.height, 0)

        UIView.animate(withDuration: duration) {
            self.view.frame = CGRect(x: self.originalFrame!.origin.x,
                                        y: self.originalFrame!.origin.y - delta,
                                        width: self.originalFrame!.width,
                                        height: self.originalFrame!.height)
        }
    }

    // Move the view back to its original position when the keyboard is dismissed
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
            }

        UIView.animate(withDuration: duration) {
            self.view.frame = self.originalFrame ?? self.view.frame
        }
    }
}
// MARK: - TableView
extension CommentViewController{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            let email = comments[indexPath.row]["email"] as! String
            let comment = comments[indexPath.row]["content"] as! String
            let imageFile = "profileImages/"+email+"_profilePicture.png"

            if let cachedImage = imageCache.object(forKey: imageFile as NSString) {
                cell.profileImage.image = cachedImage
            } else {
                cell.profileImage.image = nil

                StorageMangager.base.getURL(for: imageFile) { url in
                    ImageDownloader.downloadImage("\(url)") { image, urlString in
                        if let imageObject = image {
                            // Store the downloaded image in the cache
                            self.imageCache.setObject(imageObject, forKey: imageFile as NSString)

                            // Perform UI operations on the main thread
                            DispatchQueue.main.async {
                                // Check if the cell is still visible for the corresponding index path
                                if let cellToUpdate = tableView.cellForRow(at: indexPath) as? CommentCell {
                                    cellToUpdate.profileImage.image = imageObject
                                }
                            }
                        }
                    }
                }
            }

            cell.commentLabel.text = comment
            return cell
        }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CommentCell
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        profileVC.viewEmail = comments[indexPath.row]["email"] as! String
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}
// MARK: - TextField
extension CommentViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print(comments)
        textField.resignFirstResponder()
        DatabaseManager.base.addComment(email: email, content: textField.text!, movie: movie){ res in
            textField.text=""
            self.loadComments()
            self.resignFirstResponder()
        }
        let newComment = CommentEntity(context: context)
        newComment.content = textField.text!
        newComment.movieName = movie["title"] as? String ?? ""
        newComment.email = email
        //self.saveComment()
        //print(comments)
        return true
    }
}
