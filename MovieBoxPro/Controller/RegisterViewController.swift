//
//  RegisterViewController.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 3/15/23.
//

import UIKit
import FirebaseAuth
class RegisterViewController: UIViewController {
    
    @IBOutlet var passwordView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var nameView: UIView!
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var userText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Setting up TapImageView
        passwordView.layer.cornerRadius = passwordView.frame.size.height/2
        emailView.layer.cornerRadius = emailView.frame.size.height/2
        nameView.layer.cornerRadius = nameView.frame.size.height/2
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        profileImage.addGestureRecognizer(tapGR)
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.masksToBounds = true
        passwordText.delegate=self
        passwordText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "BrandPurple")?.withAlphaComponent(0.2) ?? UIColor.gray])
        userText.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "BrandPurple")?.withAlphaComponent(0.2) ?? UIColor.gray])
        emailText.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "BrandPurple")?.withAlphaComponent(0.2) ?? UIColor.gray])
        userText.delegate=self
        emailText.delegate=self
    }
    //Setting up TapImageView 2
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            presentChoice()
        }
    }
    @IBAction func registerPressed(_ sender: Any) {
        guard let email=emailText.text, let password=passwordText.text, let username = userText.text, let image = self.profileImage.image, !email.isEmpty, !password.isEmpty,!username.isEmpty else{
            regError(error: "Please fill in all Information")
            return
        }
        activity.startAnimating()
        RegisterLoginManager.base.register(username: username, email: email, password: password,image: image) { result in
            switch result{
            case .success(_):
                self.activity.stopAnimating()
                print("Registered")
                self.performSegue(withIdentifier: "registerToSur", sender: self)
            case .failure(let error):
                if let authErrorCode = AuthErrorCode.Code(rawValue: error.code) {
                    switch authErrorCode {
                        
                    case .emailAlreadyInUse:
                        self.regError(error: "The email address is already in use by another account.")
                    case .invalidEmail:
                        self.regError(error: "The email address is badly formatted")
                    case .weakPassword:
                        self.regError(error: "The password must be 6 characters long or more")
                    default:
                        print(error.localizedDescription)
                    }
                    self.activity.stopAnimating()
                }
            }
        }
    }
    func regError(error: String) {
        let alert = UIAlertController(title: "ERROR", message:error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentChoice(){
        let choice = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        choice.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        choice.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self]_ in
            self?.presentCamera()
        }))
        choice.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self]_ in
            self?.presentPhotoPicker()
        }))
        present(choice, animated: true)
        
    }
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage =  info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.profileImage.image = selectedImage
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension RegisterViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
