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


class FoodNameViewController: UIViewController {
    
    var isSearching: Bool = false
    var foodNames: [String] = []
    var foodId: [String] = []
    var foods: [NSManagedObject] = []
    var filteredFoodNames: [String] = []
    var imageHasilFoto : UIImage!
    let fatSecretClient = FatSecretClient()
    
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
        for(i) in foods.indices{
            foodNames.append((foods[i].value(forKeyPath:"foodName") as? String)!)
        }
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
            //            foodData.append(FoodDataSearch(foodName: searchedFood[0].name, foodId: searchedFood[0].id))
            //            print("food data : \(searchedFood)")
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FoodDetailViewController, let cell = sender as? UITableViewCell{
            let selectedRow = foodNameTableView.indexPath(for: cell)!.row
            if isSearching{
                vc.foodName = filteredFoodNames[selectedRow]
            }
            else{
                vc.foodName = foodNames[selectedRow]
            }
            vc.modalPresentationStyle = .pageSheet
        }
    }
}

extension FoodNameViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filteredFoodNames.count
        }
        else{
            return foodNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodNameCell", for: indexPath)
        if isSearching{
            cell.textLabel?.text = filteredFoodNames[indexPath.row]
        }
        else{
            cell.textLabel?.text = foodNames[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        print("Clickd : \(cell)")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            foodNameTableView.reloadData()
        } else{
            isSearching = true
            filteredFoodNames = foodNames.filter{(name: String) -> Bool in return name.range(of: searchText, options:.caseInsensitive, range: nil, locale: nil) != nil}
            foodNameTableView.reloadData()
        }
    }
    
    //Untuk search and get food nutritiont
    func search(searchName : String){
        fatSecretClient.searchFood(name: searchName) { search in
            for food in search.foods{
                self.foodNames.append(food.name)
                self.foodId.append(food.id)
                
            }
            DispatchQueue.main.async {
                self.foodNameTableView.reloadData()
            }
            
        }
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
            guard let servingsFood = food.servings else { return }
            for serving in servingsFood {
                print(serving)
                //                print("Serving Calcium : \(serving.calcium ?? "0")")
                //                print("Serving Potasium : \(serving.potassium ?? "0")")
            }
        }
    }
    
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil);
    //        let viewController = storyboard.instantiateViewController(withIdentifier: "Onboarding") as! OnboardingViewController;
    //        self.present(viewController, animated: true, completion: nil)
    //
    //    }
}
