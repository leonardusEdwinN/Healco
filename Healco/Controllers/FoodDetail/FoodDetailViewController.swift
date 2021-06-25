//
//  FoodDetailViewController.swift
//  Healco
//
//  Created by Kelny Tan on 17/06/21.
//

import UIKit

class FoodDetailViewController: UIViewController {
    
    //    var selectedData : FoodDataSearch?
    var selectedFood : FoodModel2!
    var timeToEatArray : [String] = ["Breakfast","Lunch","Dinner", "Snack"]
    var reasonToEatArray : [String] = ["It was time", "Hungry", "Social", "Bored", "Stressed", "Loved taste", "Other"]
    var feelWhenEatArray : [String] = ["😆", "😭", "😰", "😧", "😠", "🥱"]
    
    
    /*@IBOutlet weak var foodStatusImageView: UIImageView!
     @IBOutlet weak var foodNameLabel: UILabel!
     @IBOutlet weak var foodDescriptionLabel: UILabel!
     @IBOutlet weak var foodCaloriesLabel: UILabel!
     @IBOutlet weak var foodFatLabel: UILabel!
     @IBOutlet weak var foodCarbohydrateLabel: UILabel!
     @IBOutlet weak var foodProteinLabel: UILabel!*/
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var foodNameLabel: UILabel!
    
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var foodStatusImageView: UIImageView!
    @IBOutlet weak var foodDescriptionLabel: UILabel!
    
    @IBOutlet weak var viewDetailFood: UIView!
    @IBOutlet weak var foodCaloriesLabel: UILabel!
    @IBOutlet weak var foodFatLabel: UILabel!
    @IBOutlet weak var foodCarbohydrateLabel: UILabel!
    @IBOutlet weak var foodProteinLabel: UILabel!
    
    
    @IBOutlet weak var reasonToEatCollectionView: UICollectionView!
    @IBOutlet weak var timeToEatCollectionView: UICollectionView!
    @IBOutlet weak var feelWhenEatCollectionView: UICollectionView!
    
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBAction func buttonSubmitPressed(_ sender: Any) {
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeToEatCollectionView.register(UINib(nibName: "TimeToEatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "timeToEatCell")
        timeToEatCollectionView.delegate = self
        timeToEatCollectionView.dataSource = self
        timeToEatCollectionView.allowsMultipleSelection = false
        
        
        reasonToEatCollectionView.register(UINib(nibName: "ReasonToEatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "reasonToEatCell")
        reasonToEatCollectionView.delegate = self
        reasonToEatCollectionView.dataSource = self
        
        
        feelWhenEatCollectionView.register(UINib(nibName: "FeelToEatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "feelToEatCell")
        feelWhenEatCollectionView.delegate = self
        feelWhenEatCollectionView.dataSource = self
        
        buttonSubmit.layer.cornerRadius = 15
        
        setData()
    }
    
    
    func setData(){
        foodNameLabel.text = self.selectedFood.foodName
        foodDescriptionLabel.text = self.selectedFood.foodDescription
        
        //calculate food statusnya
        switch(self.selectedFood.foodStatus){
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
        foodCaloriesLabel.text = String(self.selectedFood.foodCalories) + "kal"
        foodFatLabel.text = String(self.selectedFood.foodFat) + "g"
        foodCarbohydrateLabel.text = String(self.selectedFood.foodCarbohydrate) + "g"
        foodProteinLabel.text = String(self.selectedFood.foodProtein) + "g"
    }
    
}


extension FoodDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.timeToEatCollectionView{
            return timeToEatArray.count
        }else if collectionView == self.reasonToEatCollectionView{
            return reasonToEatArray.count
        }else if collectionView == self.feelWhenEatCollectionView{
            return feelWhenEatArray.count
        }
        
        return 0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.timeToEatCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeToEatCell", for: indexPath) as! TimeToEatCollectionViewCell
            
            cell.setUI(timeToEat: timeToEatArray[indexPath.item])
//            cell.viewTimeToEat.backgroundColor = UIColor(displayP3Red: 244.0, green: 245.0, blue: 250.0, alpha: 1.0)
//            cell.labelTimeToEat.textColor = UIColor(displayP3Red: 141.0, green: 141.0, blue: 141.0, alpha: 1.0)
            return cell
        }else if collectionView == self.reasonToEatCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reasonToEatCell", for: indexPath) as! ReasonToEatCollectionViewCell
            
            cell.setUI(reasonToEat: reasonToEatArray[indexPath.item])
            return cell
        }else if collectionView == self.feelWhenEatCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feelToEatCell", for: indexPath) as! FeelToEatCollectionViewCell
            
            cell.setUI(feel: feelWhenEatArray[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.timeToEatCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! TimeToEatCollectionViewCell
            cell.changeUpdate()
        }else if collectionView == self.reasonToEatCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! ReasonToEatCollectionViewCell
            cell.changeUpdate()
        }else if collectionView == self.feelWhenEatCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! FeelToEatCollectionViewCell
            cell.changeUpdate()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.timeToEatCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! TimeToEatCollectionViewCell
            cell.changeUpdate()
        }else if collectionView == self.reasonToEatCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! ReasonToEatCollectionViewCell
            cell.changeUpdate()
        }else if collectionView == self.feelWhenEatCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! FeelToEatCollectionViewCell
            cell.changeUpdate()
        }
    }
}

