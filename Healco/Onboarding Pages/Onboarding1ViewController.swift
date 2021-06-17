//
//  Onboarding1ViewController.swift
//  Healco
//
//  Created by Kelny Tan on 17/06/21.
//

import UIKit

class Onboarding1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if let pageController = parent as? PageViewController{
            pageController.pushNext()
        }
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
