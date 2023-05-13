//
//  ExploreViewController.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/10/23.
//

import UIKit

class ExploreViewController: UIViewController {

    @IBOutlet var popularActivityViewSection: UIView!
    @IBOutlet var latestActivityViewSection: UIView!
    @IBOutlet var upcomingActivityViewSection: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIViews()
        // Do any additional setup after loading the view.
    }
    func setUpUIViews() {
//        let needSmoothCorners = [popularActivityViewSection]
//        needSmoothCorners.forEach { $0?.layer.cornerCurve = .continuous }
        let populaActivitySectionVC = UserActivitySectionViewController(sectionType: .popular)
        addChild(populaActivitySectionVC)
        popularActivityViewSection.addSubview(populaActivitySectionVC.view)
        populaActivitySectionVC.view.frame = popularActivityViewSection.bounds
        
        let latesActivitySectionVC = UserActivitySectionViewController(sectionType: .latest)
        addChild(latesActivitySectionVC)
        latestActivityViewSection.addSubview(latesActivitySectionVC.view)
        latesActivitySectionVC.view.frame = latestActivityViewSection.bounds
        
        let upcominActivitySectionVC = UserActivitySectionViewController(sectionType: .upcoming)
        addChild(upcominActivitySectionVC)
        upcomingActivityViewSection.addSubview(upcominActivitySectionVC.view)
        upcominActivitySectionVC.view.frame = upcomingActivityViewSection.bounds
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
