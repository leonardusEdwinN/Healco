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
    var namaFoto : String!
    let fatSecretClient = FatSecretClient()
    var foodData : [FoodDataSearch] = []
    //    var selectedData : FoodDataSearch?
    var selectedFood = FoodModel2()
    
    var isSearchAPI : Bool = false
    
    @IBOutlet weak var JournalHeader: UIView!
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var buttonBack: UIButton!
    //@IBOutlet weak var foodSearchBar: UISearchBar!
    @IBOutlet weak var rearchAPI: UISearchBar!
    @IBOutlet weak var foodNameTableView: UITableView!
    @IBOutlet weak var judulJenisFood: UILabel!
    @IBOutlet weak var judulSearchFood: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Method di bawah ini hanya untuk masukin test data, nanti diremove aja waktu mau gabungin, atau diubah ke data dari API
         */
        //add imagephoto ke jurnal
        imagePhoto.image = imageHasilFoto
        
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
        
        rearchAPI.delegate = self
        
        foodNameTableView.dataSource = self
        foodNameTableView.delegate = self
        JournalHeader.layer.cornerRadius = 30
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
    
    @IBAction func buttonSearchPressed(_ sender: Any) {
        if rearchAPI.text != "" {
            foodData.removeAll()
            search(searchName: rearchAPI.text ?? "")
            dismissKeyboard()
            isSearching = false
        }else{
            
        }
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
            let foodName = text.replacingOccurrences(of: "_", with: " ")
            print("nama makanannya ", foodName)
            search(searchName: foodName)
            judulJenisFood.text = "Pilih Jenis \(foodName)"
            judulSearchFood.text = "Bukan \(foodName)"
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//            if(segue.identifier == "goToDetailVC"){
//                if let vc = segue.destination as? FoodDetailViewController{
//
//                    vc.selectedFood = selectedFood // how to passing multiple parameter in prepare
//                    print("status kirim food : \(selectedFood)")
//                    vc.statusEdit = false
//                    vc.modalPresentationStyle = .pageSheet
//                }
//
//                //                if isSearching{
//                //                    vc.foodId = filteredFoodNames[selectedRow]
//                //                }
//                //                else{
////                vc.selectedFood = selectedFood
//                //                }
////                vc.modalPresentationStyle = .pageSheet
//            }
//
//
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
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text == "" {
//            isSearching = false
//            foodNameTableView.reloadData()
//        } else{
//            isSearching = true
//            //comment search function
//            //            filteredFoodNames = foodNames.filter{(name: String) -> Bool in return name.range(of: searchText, options:.caseInsensitive, range: nil, locale: nil) != nil}
//            //filteredFoodNames = foodData.filter({foodDa} -> Bool )
//            filteredFoodNames = foodData.lazy.filter { x in x.foodName.lowercased().contains(searchBar.text!.lowercased()) }
//            foodNameTableView.reloadData()
//        }
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if rearchAPI.text != "" {
            foodData.removeAll()
            search(searchName: rearchAPI.text ?? "")
            dismissKeyboard()
            isSearching = false
        }else{
            
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
    
    func calculateFood(foodModel : FoodModel2) -> HealthyStatus{
        var ifHealthy : Int = 0
        var ifCommmon : Int = 0
        var ifUnhealthy : Int = 0
        var HealthyStat : HealthyStatus!
        
        if foodModel.foodFat <= 3.0 {
            ifHealthy += 1
        }else if foodModel.foodFat > 3.0 && foodModel.foodFat <= 17.5 {
            ifCommmon += 1
        }else {
            ifUnhealthy += 1
        }
        
        if foodModel.foodProtein <= 25.0 {
            ifHealthy += 1
        }else if foodModel.foodProtein > 25.0 && foodModel.foodProtein <= 56 {
            ifCommmon += 1
        }else {
            ifUnhealthy += 1
        }
        
        if foodModel.foodSodium <= 140.0 {
            ifHealthy += 1
        }else if foodModel.foodSodium > 140 && foodModel.foodSodium <= 400 {
            ifCommmon += 1
        }else {
            ifUnhealthy += 1
        }
        
        if foodModel.foodSaturatedFat <= 1.5 {
            ifHealthy += 1
        }else if foodModel.foodSaturatedFat > 1.5 && foodModel.foodSaturatedFat <= 5 {
            ifCommmon += 1
        }else {
            ifUnhealthy += 1
        }
        
        if foodModel.foodCarbohydrate <= 65 {
            ifHealthy += 1
        }else if foodModel.foodCarbohydrate > 65 && foodModel.foodCarbohydrate <= 90 {
            ifCommmon += 1
        }else {
            ifUnhealthy += 1
        }
        
        
        if ifUnhealthy >= 1 {
            HealthyStat = HealthyStatus.unhealthy
        }else if ifCommmon > 2 && ifUnhealthy < 2 {
            HealthyStat = HealthyStatus.common
        }else if ifHealthy >= 2 && ifCommmon >= 2 {
            HealthyStat = HealthyStatus.common
        }else {
            HealthyStat = HealthyStatus.healthy
        }
        
        if ifUnhealthy > 2 {
            HealthyStat = HealthyStatus.unhealthy
        }else if ifCommmon > 2 && ifUnhealthy < 2 {
            HealthyStat = HealthyStatus.common
        }else if ifHealthy >= 2 && ifCommmon >= 2 {
            HealthyStat = HealthyStatus.healthy
        }else {
            HealthyStat = HealthyStatus.healthy
        }
        
        return HealthyStat ?? HealthyStatus.common
    }
    
    func getFood(idFood : String){
        fatSecretClient.getFood(id: idFood) { food in
            guard let servingsFood = food.servings?[0] else { return }
            
            
            let data = FoodModel2(foodName: food.name, foodDescription: "", foodCalories: Double(servingsFood.calories ?? "0.0") ?? 0.0 , foodFat: Double(servingsFood.fat ?? "0.0") ?? 0.0, foodCarbohydrate: Double(servingsFood.carbohydrate ?? "0.0") ?? 0.0, foodProtein: Double(servingsFood.protein ?? "0.0") ?? 0.0, foodSodium: Double(servingsFood.sodium ?? "0.0") ?? 0.0, foodStatus: "", foodSaturatedFat: Double(servingsFood.saturatedFat ?? "0.0") ?? 0.0)
            
            let foodStatus = self.calculateFood(foodModel: data).rawValue
            var description = ""
            
            switch foodStatus{
            case "Healthy":
                description = "You eat healthy food, Keep it going !"
            case "Common":
                description = "Not bad"
            case "Unhealthy":
                description = "Don't eat unhealthy food to much"
            default:
                print("ERROR")
            }
            
            self.selectedFood = FoodModel2(foodName: food.name, foodDescription: description, foodCalories: Double(servingsFood.calories ?? "0.0") ?? 0.0 , foodFat: Double(servingsFood.fat ?? "0.0") ?? 0.0, foodCarbohydrate: Double(servingsFood.carbohydrate ?? "0.0") ?? 0.0, foodProtein: Double(servingsFood.protein ?? "0.0") ?? 0.0, foodSodium: Double(servingsFood.sodium ?? "0.0") ?? 0.0, foodStatus: foodStatus, foodSaturatedFat: Double(servingsFood.saturatedFat ?? "0.0") ?? 0.0)
            
            
            //print("DATA SELECTED FOOD : \(self.selectedFood)")
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "FoodDetail", bundle: nil);
                let vc = storyboard.instantiateViewController(withIdentifier: "FoodDetailViewController") as! FoodDetailViewController
                vc.selectedFood = self.selectedFood
                //vc.imageHasilPhoto = self.imageHasilFoto
                vc.namaFoto = self.namaFoto
                vc.statusEdit = false
                vc.modalPresentationStyle = .pageSheet
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
