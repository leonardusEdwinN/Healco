//
//  LinkingViewController.swift
//  Healco
//
//  Created by Kelny Tan on 17/06/21.
//

import UIKit

/*
    Class penghubung kedua storyboard dengan LandscapeManager
 */
class LinkingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if LandscapeManager.shared.isFirstLaunch{
            performSegue(withIdentifier: "toOnboarding", sender: nil)
        }else{
            performSegue(withIdentifier: "toMain", sender: nil)
        }
    }
}

extension UIStoryboard{
    static let onboarding = UIStoryboard(name: "Onboarding", bundle: nil)
    static let main = UIStoryboard(name: "Main", bundle: nil)
}
