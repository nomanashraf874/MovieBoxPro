//
//  LoginViewController.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 3/31/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet var passwordView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordView.layer.cornerRadius = passwordView.frame.size.height/2
        emailView.layer.cornerRadius = emailView.frame.size.height/2
        passwordText.delegate=self
        passwordText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "BrandLightPurple")?.withAlphaComponent(0.5) ?? UIColor.gray])
        emailText.delegate=self
        emailText.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "BrandLightPurple")?.withAlphaComponent(0.5) ?? UIColor.gray])
        // Do any additional setup after loading the view.
    }
    @IBAction func LoginPressed(_ sender: Any) {
        guard let email=emailText.text, let password=passwordText.text, !email.isEmpty, !password.isEmpty else{
            loginError(error: "Please fill in all Information")
            return
        }
        activity.startAnimating()
        RegisterLoginManager.base.login(email: email, password: password) { result in
            switch result{
            case .success(_):
                self.activity.stopAnimating()
                print("Loggedin")
                self.performSegue(withIdentifier: "loginToLog", sender: self)
            case .failure(let error):
                if let authErrorCode = AuthErrorCode.Code(rawValue: error.code) {
                    switch authErrorCode {
                    case .wrongPassword:
                        self.loginError(error: "The password is invalid")
                    case .invalidEmail:
                        self.loginError(error: "Invalid email")
                    default:
                        print(error.localizedDescription)
                    }
                    self.activity.stopAnimating()
                }
            }
        }
    }
    func loginError(error: String) {
        self.activity.stopAnimating()
        let alert = UIAlertController(title: "ERROR", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

