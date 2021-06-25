//
//  FoodDetailViewController.swift
//  Healco
//
//  Created by Kelny Tan on 17/06/21.
//

import UIKit
import CoreData

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
        
        
        reasonToEatCollectionView.register(UINib(nibName: "ReasonToEatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "reasonToEatCell")
        reasonToEatCollectionView.delegate = self
        reasonToEatCollectionView.dataSource = self
        
        
        feelWhenEatCollectionView.register(UINib(nibName: "FeelToEatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "feelToEatCell")
        feelWhenEatCollectionView.delegate = self
        feelWhenEatCollectionView.dataSource = self
        
        buttonSubmit.layer.cornerRadius = 15
        
        setData()
        getSelectedDataIntoCoreData() // masukin data selectedFood ke CoreData
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
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        let totalCellWidth = 80 * collectionView.numberOfItems(inSection: 0)
//        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
//
//        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
        if collectionView == self.timeToEatCollectionView{
            return CGSize(width: 100.0, height: 30.0)
        }else if collectionView == self.reasonToEatCollectionView{
            return CGSize(width: 75.0, height: 30.0)
        }else if collectionView == self.feelWhenEatCollectionView{
            return CGSize(width: 50.0, height: 50.0)
        }
        return CGSize(width: 0, height: 0)
           
        }
    
    func getSelectedDataIntoCoreData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let detailFood = self.selectedFood
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Foods", in: managedContext)!
        let food = NSManagedObject(entity: entity, insertInto: managedContext)
        food.setValue(detailFood?.foodName, forKeyPath: "foodName")
        food.setValue(detailFood?.foodDescription, forKeyPath: "foodDescription")
        food.setValue(detailFood?.foodCalories, forKeyPath: "foodCalories")
        food.setValue(detailFood?.foodFat, forKeyPath: "foodFat")
        food.setValue(detailFood?.foodCarbohydrate, forKeyPath: "foodCarbohydrate")
        food.setValue(detailFood?.foodProtein, forKeyPath: "foodProtein")
        food.setValue(detailFood?.foodStatus, forKeyPath: "foodStatus")
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Error! \(error) \(error.userInfo)")
        }
    }
}
