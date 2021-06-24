//
//  FoodDetailViewController.swift
//  Healco
//
//  Created by Kelny Tan on 17/06/21.
//

import UIKit
import FatSecretSwift

class FoodDetailViewController: UIViewController {

    var selectedData : FoodDataSearch?
    let fatSecretClient = FatSecretClient()
    var selectedFood = FoodModel2()
    
    /*@IBOutlet weak var foodStatusImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodDescriptionLabel: UILabel!
    @IBOutlet weak var foodCaloriesLabel: UILabel!
    @IBOutlet weak var foodFatLabel: UILabel!
    @IBOutlet weak var foodCarbohydrateLabel: UILabel!
    @IBOutlet weak var foodProteinLabel: UILabel!*/
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodDescriptionLabel: UILabel!
    @IBOutlet weak var foodCaloriesLabel: UILabel!
    @IBOutlet weak var foodFatLabel: UILabel!
    @IBOutlet weak var foodCarbohydrateLabel: UILabel!
    @IBOutlet weak var foodProteinLabel: UILabel!
    @IBOutlet weak var foodStatusImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FOOD : \(selectedData?.foodId)")
//        let foodSelected = getFoodFromName(name: foodName)
        getFood(idFood: selectedData?.foodId ?? "1")
//        foodNameLabel.text = foodSelected.foodName
//        foodDescriptionLabel.text = foodSelected.foodDescription
//        switch(foodSelected.foodStatus){
//        case "Healthy":
//            foodStatusImageView.image = UIImage(named: "healthy-icon")
//            foodCaloriesLabel.textColor = UIColor.green
//            break
//        case "Common":
//            foodStatusImageView.image = UIImage(named: "common-icon")
//            foodCaloriesLabel.textColor = UIColor.orange
//            break
//        case "Unhealthy":
//            foodStatusImageView.image = UIImage(named: "unhealthy-icon")
//            foodCaloriesLabel.textColor = UIColor.red
//            break
//        default:
//            break
//        }
//        foodCaloriesLabel.text = String(foodSelected.foodCalories) + "kal"
//        foodFatLabel.text = String(foodSelected.foodFat) + "g"
//        foodCarbohydrateLabel.text = String(foodSelected.foodCarbohydrate) + "g"
//        foodProteinLabel.text = String(foodSelected.foodProtein) + "g"
    }
    
    func getFood(idFood : String){
        fatSecretClient.getFood(id: idFood) { food in
            print("FOOD NAME : \(food.name)")
            print("FOOD ID : \(food.id)")
            //            print("FOOD DESC : \(String(describing: food.servings.serving))")
            //            for serving in food.servings!{
            //                print("Serving : \(serving) \n")
            //            }
            //
            guard let servingsFood = food.servings?[0] else { return }
            
            self.selectedFood = FoodModel2(foodName: food.name, foodDescription: "", foodCalories: Double(servingsFood.calories ?? "0.0") ?? 0.0 , foodFat: Double(servingsFood.fat ?? "0.0") ?? 0.0, foodCarbohydrate: Double(servingsFood.carbohydrate ?? "0.0") ?? 0.0, foodProtein: Double(servingsFood.protein ?? "0.0") ?? 0.0, foodSodium: Double(servingsFood.sodium ?? "0.0") ?? 0.0, foodStatus: "", foodSaturatedFat: Double(servingsFood.saturatedFat ?? "0.0") ?? 0.0)
            
            print("data : \(self.selectedFood)")
            
        }
    }
    
}
