//
//  ViewController.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 09/06/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil);
        let viewController = storyboard.instantiateViewController(withIdentifier: "Onboarding") as! OnboardingViewController;
        self.present(viewController, animated: true, completion: nil)
    }
}

