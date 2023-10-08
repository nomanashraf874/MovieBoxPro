//
//  WelcomeViewController.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 3/13/23.
//
//add models
//new app

import UIKit
import FirebaseAuth
class WelcomeViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        checkIfLoggedIn()
        titleLabel.text=""
        var index = 0;
        let titleText = "MovieBox"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2*Double(index), repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            index = index+1;
        }
    }
    private func checkIfLoggedIn(){
        if FirebaseAuth.Auth.auth().currentUser != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "already")
            self.present(vc,animated: true)
        }
    }
    @IBAction func unwindToWeclome(unwindSegue: UIStoryboardSegue){

    }

}

