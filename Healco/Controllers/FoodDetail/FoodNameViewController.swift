//
//  FoodNameViewController.swift
//  Healco
//
//  Created by Kelny Tan on 23/06/21.
//

import UIKit
import CoreData
import Foundation
import AVKit
import Vision
import FatSecretSwift

struct FoodDataSearch {
    var foodName : String
    var foodId : String
}


class FoodNameViewController: UIViewController {
    
    var isSearching: Bool = false
    //    var foodNames: [String] = []
    var foods: [NSManagedObject] = []
    var filteredFoodNames: [FoodDataSearch] = []
    var imageHasilFoto : UIImage!
    let fatSecretClient = FatSecretClient()
    var foodData : [FoodDataSearch] = []
    //    var selectedData : FoodDataSearch?
    var selectedFood = FoodModel2()
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var foodSearchBar: UISearchBar!
    @IBOutlet weak var foodNameTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Method di bawah ini hanya untuk masukin test data, nanti diremove aja waktu mau gabungin, atau diubah ke data dari API
         */
        //addDataToFoodCoreData()
        analyzeImage(image: imageHasilFoto)
        
        foods = fetchDataFromFoodCoreData()
        //deleteRequest()
        //        print(foods.count)
        // masukin nama ke array nama, karena untuk filter nanti
        
        //filter food name
        //        for(i) in foods.indices{
        //            foodNames.append((foods[i].value(forKeyPath:"foodName") as? String)!)
        //        }
        foodNameTableView.reloadData()
        
        // ==================
        
        foodSearchBar.delegate = self
        foodNameTableView.dataSource = self
        foodNameTableView.delegate = self
        //
        //        self.foodData.insert(FoodDataSearch(foodName: "DUmmy", foodId: "1"), at: 0)
        //        print("\(self.foodData[0].foodName)")
        
    }
    
    //    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    //        print("Camera was able to capture a frame:", Date())
    //
    //        guard let model = try? VNCoreMLModel(for:  Food101().model) else{return}
    //        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
    //
    //        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
    //            guard let result = finishedReq.results as? [VNClassificationObservation] else {return}
    //
    //            guard let firstObservation = result.first else {return}
    //            print(firstObservation.identifier, firstObservation.confidence)
    //        }
    //
    //        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    //    }
    
    @IBAction func buttonBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func analyzeImage (image: UIImage?){
        guard let buffer = image?.resize(size: CGSize(width: 299, height: 299))?
                .getCVPixelBuffer() else {
            return
        }
        
        do {
            let config = MLModelConfiguration()
            let model = try Food101(configuration: config)
            let input = Food101Input(image:  buffer)
            
            let output = try model.prediction(input: input)
            let text = output.classLabel
            print("nama makanannya ", text)
            search(searchName: text)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if let vc = segue.destination as? FoodDetailViewController{
//
//            if(segue.identifier == "goToDetailVC"){
//                //                if isSearching{
//                //                    vc.foodId = filteredFoodNames[selectedRow]
//                //                }
//                //                else{
//                vc.selectedFood = selectedFood
//                //                }
//                vc.modalPresentationStyle = .pageSheet
//            }
//
//        }
//    }
}

extension FoodNameViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filteredFoodNames.count
        }
        else{
            return foodData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodNameCell", for: indexPath)
        if isSearching{
            cell.textLabel?.text = filteredFoodNames[indexPath.row].foodName
        }
        else{
            cell.textLabel?.text = foodData[indexPath.row].foodName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        selectedData = FoodDataSearch(foodName: foodData[indexPath.row].foodName, foodId: foodData[indexPath.row].foodId)
        getFood(idFood: foodData[indexPath.row].foodId)
        //        performSegue(withIdentifier: "goToDetailVC", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            foodNameTableView.reloadData()
        } else{
            isSearching = true
            //comment search function
            //            filteredFoodNames = foodNames.filter{(name: String) -> Bool in return name.range(of: searchText, options:.caseInsensitive, range: nil, locale: nil) != nil}
            //filteredFoodNames = foodData.filter({foodDa} -> Bool )
            filteredFoodNames = foodData.lazy.filter { x in x.foodName.lowercased().contains(searchBar.text!.lowercased()) }
            foodNameTableView.reloadData()
        }
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil);
    //        let viewController = storyboard.instantiateViewController(withIdentifier: "Onboarding") as! OnboardingViewController;
    //        self.present(viewController, animated: true, completion: nil)
    //
    //    }
}

// MARK : - USING API TO SEARCH FOOD AND GET DATA
extension FoodNameViewController {
    func search(searchName : String){
        fatSecretClient.searchFood(name: searchName) { search in
            for food in search.foods{
                self.foodData.append(FoodDataSearch(foodName: food.name, foodId: food.id))
                
            }
            DispatchQueue.main.async {
                self.foodNameTableView.reloadData()
            }
            
        }
    }
    
    func getFood(idFood : String){
        fatSecretClient.getFood(id: idFood) { food in
            guard let servingsFood = food.servings?[0] else { return }
            
            self.selectedFood = FoodModel2(foodName: food.name, foodDescription: "", foodCalories: Double(servingsFood.calories ?? "0.0") ?? 0.0 , foodFat: Double(servingsFood.fat ?? "0.0") ?? 0.0, foodCarbohydrate: Double(servingsFood.carbohydrate ?? "0.0") ?? 0.0, foodProtein: Double(servingsFood.protein ?? "0.0") ?? 0.0, foodSodium: Double(servingsFood.sodium ?? "0.0") ?? 0.0, foodStatus: "", foodSaturatedFat: Double(servingsFood.saturatedFat ?? "0.0") ?? 0.0)
            
            print("DATA SELECTED FOOD : \(self.selectedFood)")
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "FoodDetail", bundle: nil);
                let vc = storyboard.instantiateViewController(withIdentifier: "FoodDetailViewController") as! FoodDetailViewController
                vc.selectedFood = self.selectedFood
                vc.modalPresentationStyle = .pageSheet
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
    }
}
