//
//  HomeTabBar.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 29/07/21.
//

import Foundation
import UIKit


class HomeTabBar : UITabBarController,UITabBarControllerDelegate{
    
    required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            self.delegate = self
            self.setupMiddleButton()
       }
    
    // TabBarButton – Setup Middle Button
        func setupMiddleButton() {

            let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
            let gradient = CAGradientLayer()

//            gradient.frame = middleBtn.bounds
//            gradient.colors = [UIColor.gray.cgColor, UIColor.green.cgColor]
            
//            STYLE THE BUTTON YOUR OWN WAY
            middleBtn.setImage(UIImage(named: "addIcon"), for: .normal)
            middleBtn.tintColor = .white
//            middleBtn.layer.insertSublayer(gradient, at: 0)
            middleBtn.layer.backgroundColor = UIColor(named: "AvocadoGreen")?.cgColor
            middleBtn.layer.cornerRadius = middleBtn.bounds.size.width / 2
            
            //add to the tabbar and add click event
            self.tabBar.addSubview(middleBtn)
            middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)

            self.view.layoutIfNeeded()
        }

        // Menu Button Touch Action
        @objc func menuButtonAction(sender: UIButton) {
            self.selectedIndex = 2   //to select the middle tab. use "1" if you have only 3 tabs.
            print("YUHU")
//            performSegue(withIdentifier: "goToFoodRecog", sender: self)
            
        }
    

}



