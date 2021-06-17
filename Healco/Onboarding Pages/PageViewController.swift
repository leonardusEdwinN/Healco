//
//  PageViewController.swift
//  Healco
//
//  Created by Kelny Tan on 17/06/21.
//

import UIKit

class PageViewController: UIPageViewController {

    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewControllers([viewControllerList()[0]], direction: .forward, animated: false, completion: nil)
    }
    
    private func viewControllerList() -> [UIViewController]{
        let storyboard = UIStoryboard.onboarding
        let vc1 = storyboard.instantiateViewController(identifier: "Onboarding1VC")
        let vc2 = storyboard.instantiateViewController(identifier: "Onboarding2VC")
        let vc3 = storyboard.instantiateViewController(identifier: "Onboarding3VC")
        return [vc1, vc2, vc3]
    }
    
    func pushNext(){
        if currentIndex + 1 < viewControllerList().count{
            
            self.setViewControllers([self.viewControllerList()[self.currentIndex + 1]], direction: .forward, animated: true, completion: nil)
            currentIndex += 1
        }
    }
}
