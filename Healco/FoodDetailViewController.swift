//
//  FoodDetailViewController.swift
//  Healco
//
//  Created by Kelny Tan on 17/06/21.
//

import UIKit

class FoodDetailViewController: UIViewController {

    var foodName: String!
    
    /*@IBOutlet weak var foodStatusImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodDescriptionLabel: UILabel!
    @IBOutlet weak var foodCaloriesLabel: UILabel!
    @IBOutlet weak var foodFatLabel: UILabel!
    @IBOutlet weak var foodCarbohydrateLabel: UILabel!
    @IBOutlet weak var foodProteinLabel: UILabel!*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*let foodSelected = getFoodFromName(name: foodName!)
        foodNameLabel.text = foodSelected.foodName
        foodDescriptionLabel.text = foodSelected.foodDescription
        switch(foodSelected.foodStatus){
        case "Healthy":
            foodStatusImageView.image = UIImage(named: "healthy-icon")
            foodCaloriesLabel.textColor = UIColor.green
            break
        case "Common":
            foodStatusImageView.image = UIImage(named: "common-icon")
            foodCaloriesLabel.textColor = UIColor.orange
            break
        case "Unhealthy":
            foodStatusImageView.image = UIImage(named: "unhealthy-icon")
            foodCaloriesLabel.textColor = UIColor.red
            break
        default:
            break
        }
        foodCaloriesLabel.text = String(foodSelected.foodCalories) + "kal"
        foodFatLabel.text = String(foodSelected.foodFat) + "g"
        foodCarbohydrateLabel.text = String(foodSelected.foodCarbohydrate) + "g"
        foodProteinLabel.text = String(foodSelected.foodProtein) + "g"*/
    }

    @IBAction func backButton_Pressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
