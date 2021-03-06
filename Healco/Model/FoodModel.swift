//
//  FoodModel.swift
//  Healco
//
//  Created by Kelny Tan on 17/06/21.
//

import Foundation
import CoreData
import UIKit

struct FoodModel{
    var foodName: String!
    var foodDescription: String!
    var foodCalories: Double!
    var foodFat: Double!
    var foodCarbohydrate: Double!
    var foodProtein: Double!
    var foodStatus: String!
}

enum HealthyStatus: String{
    case healthy = "Healthy"
    case common = "Common"
    case unhealthy = "Unhealthy"
}

func addDataToModel()->[FoodModel]{
    var model: [FoodModel] = []
    let item1: FoodModel = FoodModel(foodName: "aslnbvsdk", foodDescription: "adjkbfd", foodCalories: 100, foodFat: 67.8, foodCarbohydrate: 87, foodProtein: 75, foodStatus: HealthyStatus.healthy.rawValue)
    let item2: FoodModel = FoodModel(foodName: "aEdbcned", foodDescription: "Qslkdvbnds", foodCalories: 150, foodFat: 92, foodCarbohydrate: 120, foodProtein: 150, foodStatus: HealthyStatus.unhealthy.rawValue)
    let item3: FoodModel = FoodModel(foodName: "Aaklsdvbned", foodDescription: "ewfQdkvn", foodCalories: 200, foodFat: 50.8, foodCarbohydrate: 100, foodProtein: 55, foodStatus: HealthyStatus.common.rawValue)
    let item4: FoodModel = FoodModel(foodName: "Nasi Goreng", foodDescription: "Nasi digoreng nikmat", foodCalories: 160, foodFat: 78, foodCarbohydrate: 120.5, foodProtein: 68.5, foodStatus: HealthyStatus.unhealthy.rawValue)
    model.append(item1)
    model.append(item2)
    model.append(item3)
    model.append(item4)
    return model
}

public func addDataToFoodCoreData(){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
        return
    }
    let models = addDataToModel()
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Foods", in: managedContext)!
    for(i) in models.indices{
        let food = NSManagedObject(entity: entity, insertInto: managedContext)
        food.setValue(models[i].foodName, forKeyPath: "foodName")
        food.setValue(models[i].foodDescription, forKeyPath: "foodDescription")
        food.setValue(models[i].foodCalories, forKeyPath: "foodCalories")
        food.setValue(models[i].foodFat, forKeyPath: "foodFat")
        food.setValue(models[i].foodCarbohydrate, forKeyPath: "foodCarbohydrate")
        food.setValue(models[i].foodProtein, forKeyPath: "foodProtein")
        food.setValue(models[i].foodStatus, forKeyPath: "foodStatus")
    }
    do{
        try managedContext.save()
    }catch let error as NSError{
        print("Error! \(error) \(error.userInfo)")
    }
}

public func fetchDataFromFoodCoreData()->[NSManagedObject]{
    var data: [NSManagedObject] = []
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let managedContext = appDelegate!.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Foods")
    do{
        try data = managedContext.fetch(fetchRequest)
    }catch let error as NSError{
        print("\(error)")
    }
    return data
}

func putDataIntoArray()->[FoodModel]{
    let foodData: [NSManagedObject] = fetchDataFromFoodCoreData()
    var array: [FoodModel] = []
    for(i) in foodData.indices{
        array.append(FoodModel(foodName: foodData[i].value(forKeyPath: "foodName") as? String, foodDescription: foodData[i].value(forKeyPath: "foodDescription" ) as? String, foodCalories: foodData[i].value(forKeyPath: "foodCalories") as? Double, foodFat: foodData[i].value(forKeyPath: "foodFat") as? Double, foodCarbohydrate: foodData[i].value(forKeyPath: "foodCarbohydrate") as? Double, foodProtein: foodData[i].value(forKeyPath: "foodProtein") as? Double, foodStatus: foodData[i].value(forKeyPath: "foodStatus") as? String))
    }
    return array
}

func getFoodFromName(name: String)->FoodModel
{
    var food: FoodModel?
    let foodData = putDataIntoArray()
    for(i) in foodData.indices{
        if(foodData[i].foodName == name){
            food = foodData[i]
            return food!
        }
    }
    return food!
}

public func deleteRequest(){
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let managedContext = appDelegate!.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Foods")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
        try managedContext.execute(deleteRequest)
    } catch let error as NSError {
        // TODO: handle the error
    }
}
