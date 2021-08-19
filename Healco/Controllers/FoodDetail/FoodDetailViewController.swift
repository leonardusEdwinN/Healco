//
//  FoodDetailViewController.swift
//  Healco
//
//  Created by Kelny Tan on 17/06/21.
//

import UIKit
import CoreData


class FoodDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //    var selectedData : FoodDataSearch?
    var porsiMakanan: [Int] = []
    var satuanPorsi: [String] = ["gr", "pcs", "cup"]
    var informasiMakanan: [String] = ["Karbohidrat", "Protein"]
    var selectedFood : FoodModel2!
    var timeToEatArray : [String] = ["Breakfast","Lunch","Dinner", "Snack"]
    var reasonToEatArray : [String] = ["Gak Ada", "Ada Acara", "Nongkrong", "Nonton", "Belajar", "Kerja"]
    var feelWhenEatArray : [String] = ["😃 Biasa Aja", "😆 Bahagia", "😢 Sedih", "😫 Galau", "🤯 Stress", "😡 Marah"]
    var imageHasilPhoto : UIImage!
    var namaFoto : String!
    let data = CoreDataClass()
    
    
    /*@IBOutlet weak var foodStatusImageView: UIImageView!
     @IBOutlet weak var foodNameLabel: UILabel!
     @IBOutlet weak var foodDescriptionLabel: UILabel!
     @IBOutlet weak var foodCaloriesLabel: UILabel!
     @IBOutlet weak var foodFatLabel: UILabel!
     @IBOutlet weak var foodCarbohydrateLabel: UILabel!
     @IBOutlet weak var foodProteinLabel: UILabel!*/
 
    //headerView
    @IBOutlet weak var viewHeaderFoodDetail: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var buttonSimpanOrUbah: UIButton!
    
    //journalingView
    @IBOutlet weak var foodNameLabel: UILabel!
    
    //Nutrisi Makananmu Top
    //========
    @IBOutlet weak var viewTopNutrition: UIView!
    @IBOutlet weak var labelNutrisiMakananmuTop: UILabel!
    //kal View Kalori
    @IBOutlet weak var viewKaloriTop: UIView!
    @IBOutlet weak var labelKaloriTextTop: UILabel!
    @IBOutlet weak var labelKaloriValueTop: UILabel!
    //kal View Karbohidrat
    @IBOutlet weak var viewKarbohidratTop: UIView!
    @IBOutlet weak var labelKarbohidratTextTop: UILabel!
    @IBOutlet weak var labelKarbohidratValueTop: UILabel!
    //kal View kalori
    @IBOutlet weak var viewProteinTop: UIView!
    @IBOutlet weak var labelProteinTextTop: UILabel!
    @IBOutlet weak var labelProteinValueTop: UILabel!
    //kal View kalori
    @IBOutlet weak var viewLemakTop: UIView!
    @IBOutlet weak var labelLemakTextTop: UILabel!
    @IBOutlet weak var labelLemakValueTop: UILabel!
    //===========
    
    
    @IBOutlet weak var porsiPickerView: UIPickerView!
    
    @IBOutlet weak var labelMakanBerapaBanyak: UILabel!
    @IBOutlet weak var pickerviewPorsi: UIPickerView!
    
    @IBOutlet weak var labelKapanMakannya: UILabel!
    @IBOutlet weak var timeToEatCollectionView: UICollectionView!
    
    @IBOutlet weak var labelMoodnyaGimana: UILabel!
    @IBOutlet weak var feelWhenEatCollectionView: UICollectionView!
    
    @IBOutlet weak var labelLagiNgapainPasMakan: UILabel!
    @IBOutlet weak var reasonToEatCollectionView: UICollectionView!
    
    
    //Nutrisi Makananmu Bottom
    //========
    @IBOutlet weak var viewBottomNutrition: UIView!
    @IBOutlet weak var labelNutrisiMakananmuBottom: UILabel!
    //kal View Kalori
    @IBOutlet weak var viewKaloriBottom: UIView!
    @IBOutlet weak var labelKaloriTextBottom: UILabel!
    @IBOutlet weak var labelKaloriValueBottom: UILabel!
    //kal View Karbohidrat
    @IBOutlet weak var viewKarbohidratBottom: UIView!
    @IBOutlet weak var labelKarbohidratTextBottom: UILabel!
    @IBOutlet weak var labelKarbohidratValueBottom: UILabel!
    //kal View kalori
    @IBOutlet weak var viewProteinBottom: UIView!
    @IBOutlet weak var labelProteinTextBottom: UILabel!
    @IBOutlet weak var labelProteinValueBottom: UILabel!
    //kal View kalori
    @IBOutlet weak var viewLemakBottom: UIView!
    @IBOutlet weak var labelLemakTextBottom: UILabel!
    @IBOutlet weak var labelLemakValueBottom: UILabel!
    //===========
    
    @IBOutlet weak var buttonHapus: UIButton!
    
//    @IBOutlet weak var viewDescription: UIView!
//    @IBOutlet weak var foodDescriptionLabel: UILabel!
//    @IBOutlet weak var viewDetailFood: UIView!
//    @IBOutlet weak var foodCaloriesLabel: UILabel!
//    @IBOutlet weak var foodFatLabel: UILabel!
//    @IBOutlet weak var foodCarbohydrateLabel: UILabel!
//    @IBOutlet weak var foodProteinLabel: UILabel!
   
    
    var selectedReason: String?
    var selectedTime: String?
    var selectedFeel: String?
    var statusEdit: Bool = false // untuk button status
    var isUpdate: Bool = false // untuk button status
    var selectedPorsi : Int?
    var selectedSatuan : String?
    var totalLemak : Float!
    var totalProtein : Float!
    var totalKarbohidrat : Float!
    var totalKalori : Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for  n in 1...1000 {
            porsiMakanan.append(n)
        }
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ubah", style: .plain, target: self, action: #selector(btnEdit_Pressed))
        
        pickerviewPorsi.dataSource = self
        pickerviewPorsi.delegate = self
        print("status Edit : \(statusEdit)")
        print("status food : \(selectedFood)")
        
        if(statusEdit){
            self.buttonSimpanOrUbah.setTitle("Ubah", for: .normal)
            self.viewTopNutrition.isHidden = false
            self.viewBottomNutrition.isHidden = true
            
            viewBottomNutrition.translatesAutoresizingMaskIntoConstraints = false
            viewBottomNutrition.heightAnchor.constraint(equalToConstant: 0).isActive = true
            viewTopNutrition.heightAnchor.constraint(equalToConstant: 0).isActive = false
            
            
            self.buttonHapus.isHidden = true
//            buttonHapus.translatesAutoresizingMaskIntoConstraints = false
//            buttonHapus.heightAnchor.constraint(equalToConstant: 0).isActive = true
            
        }else{
            self.buttonSimpanOrUbah.setTitle("Simpan", for: .normal)
            self.viewTopNutrition.isHidden = true
            self.viewBottomNutrition.isHidden = false
            
            
            viewTopNutrition.translatesAutoresizingMaskIntoConstraints = false
            viewTopNutrition.heightAnchor.constraint(equalToConstant: 0).isActive = true
            viewBottomNutrition.heightAnchor.constraint(equalToConstant: 0).isActive = false
            
            
            self.buttonHapus.isHidden = true
//            buttonHapus.translatesAutoresizingMaskIntoConstraints = false
//            buttonHapus.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        
        
        
        setData()
        settingUiToViewController()
        registerCellToCollectionView()
        //getSelectedDataIntoCoreData() // masukin data selectedFood ke CoreData
    }
    
    @IBAction func buttonHapusPressed(_ sender: Any) {
//        data.deleteJournal(journal: JournalEntity())
        print("DELETING JOURNAL >>>>> ..... >>>> ..... >>>> DONE")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonSimpanOrUbahClicked(_ sender: Any) {
        if(statusEdit){
            //dari ubah di click dulu jadi simpan
            self.buttonSimpanOrUbah.setTitle("Simpan", for: .normal)
            
            self.buttonHapus.isHidden = false
            self.buttonHapus.backgroundColor = UIColor(named: "PinkBerry")
//            buttonHapus.translatesAutoresizingMaskIntoConstraints = false
//            buttonHapus.heightAnchor.constraint(equalToConstant: 50).isActive = true
//            buttonHapus.bottomAnchor.constraint(equalTo: viewBottomNutrition.topAnchor).isActive = true
            
            self.isUpdate = true
            self.statusEdit = !self.statusEdit
        }else{
            
            if(!isUpdate){
                //nambah data baru
                print("ADD DATA")
                
                totalLemak = Float(selectedPorsi ?? 0) * Float (selectedFood.foodFat)
                totalProtein = Float(selectedPorsi ?? 0) * Float (selectedFood.foodProtein)
                totalKarbohidrat = Float(selectedPorsi ?? 0) * Float (selectedFood.foodCarbohydrate)
                totalKalori = Float(selectedPorsi ?? 0) * Float (selectedFood.foodCalories)
                
                data.addJournal(lagiApa: selectedReason ?? reasonToEatArray[0], perasaan: selectedFeel ?? feelWhenEatArray[0], porsi: Double(selectedPorsi ?? porsiMakanan[0]), satuan: satuanPorsi[0], tanggalJam: getTodayDate() , tipe: selectedTime ?? satuanPorsi[0], idMeal: selectedFood.foodId , nama: selectedFood.foodName, deskripsi: selectedFood.foodDescription, karbohidrat: Int32(selectedFood.foodCarbohydrate), lemak: Int32(selectedFood.foodFat), protein: Int32(selectedFood.foodProtein), gambar: namaFoto, kaloriTotal: Int32(totalKalori), lemakTotal: Int32(totalLemak), proteinTotal: Int32(totalProtein), karbohidratTotal: Int32(totalKarbohidrat), kalori: Int32(selectedFood.foodCalories))
                self.isUpdate = !self.isUpdate
                self.performSegue(withIdentifier: "goToHome", sender: sender)
            }else{
                //data udpdate
                
                totalLemak = Float(selectedPorsi ?? 0) * Float (selectedFood.foodFat)
                totalProtein = Float(selectedPorsi ?? 0) * Float (selectedFood.foodProtein)
                totalKarbohidrat = Float(selectedPorsi ?? 0) * Float (selectedFood.foodCarbohydrate)
                totalKalori = Float(selectedPorsi ?? 0) * Float (selectedFood.foodCalories)
                
//                data.updateJournal(journal: JournalEntity(), lagiApa: selectedReason ?? reasonToEatArray[0], perasaan: selectedFeel ?? feelWhenEatArray[0], porsi: Double(selectedPorsi ?? porsiMakanan[0]), satuan: satuanPorsi[0], tanggalJam: getTodayDate(), tipe: selectedTime ?? satuanPorsi[0], kalori: Int32(selectedFood.foodCalories), idMeal: selectedFood.foodId, nama: selectedFood.foodName, deskripsi: selectedFood.foodDescription, karbohidrat: Int32(selectedFood.foodCarbohydrate), lemak: Int32(selectedFood.foodFat), protein: Int32(selectedFood.foodProtein), gambar: selectedFood.foodImage, kaloriTotal: Int32(totalKalori), lemakTotal: Int32(totalLemak), proteinTotal: Int32(totalProtein), karbohidratTotal: Int32(totalKarbohidrat))
                
                print("UPDATING DATA.... PLEASE WAIT ....")
               
                self.performSegue(withIdentifier: "goToHome", sender: sender)
            }
        }
        
        
        
        

//        data.addJournal(lagiApa: "\(String(describing: selectedReason))", perasaan: "\(String(describing: selectedFeel))", porsi: Double(selectedPorsi ?? 0), satuan: "\(String(describing: selectedSatuan))", tanggalJam: Date(), tipe: "\(String(describing: selectedTime))", idMeal: selectedFood.foodStatus, nama: selectedFood.foodName, deskripsi: selectedFood.foodDescription, karbohidrat: Int32(selectedFood.foodCarbohydrate), lemak: Int32(selectedFood.foodFat), protein: Int32(selectedFood.foodProtein), gambar: Data(), kaloriTotal: Int32(selectedFood.foodCalories), lemakTotal: Int32(totalLemak), proteinTotal: Int32(totalProtein), karbohidratTotal: Int32(totalKarbohidrat), kalori: Int32(selectedFood.foodCalories))
        
        


        //print("total kalori \(totalKalori) || total protein \(totalProtein)")
        
        
    }
    
    
    @IBAction func buttonHappusPressed(_ sender: Any) {
    }
    
    func getTodayDate() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var finishedDate = calendar.date(byAdding: .hour, value: 7, to: Date())
        var hourComponent = DateComponents()
        hourComponent.hour = 0

        finishedDate = calendar.nextDate(after: finishedDate ?? Date(), matching: hourComponent,
                                         matchingPolicy: .nextTime, direction: .backward)
        return finishedDate ?? Date()
    }
    
    func registerCellToCollectionView(){
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
    }
    
    func settingUiToViewController(){
        viewHeaderFoodDetail.layer.cornerRadius = 15
        
        
        viewKarbohidratTop.layer.cornerRadius = 15
        viewKarbohidratTop.dropShadow()
        viewKaloriTop.layer.cornerRadius = 15
        viewKaloriTop.dropShadow()
        viewProteinTop.layer.cornerRadius = 15
        viewProteinTop.dropShadow()
        viewLemakTop.layer.cornerRadius = 15
        viewLemakTop.dropShadow()
        
        
        viewKarbohidratBottom.layer.cornerRadius = 15
        viewKarbohidratBottom.dropShadow()
        viewKaloriBottom.layer.cornerRadius = 15
        viewKaloriBottom.dropShadow()
        viewLemakBottom.layer.cornerRadius = 15
        viewLemakBottom.dropShadow()
        viewProteinBottom.layer.cornerRadius = 15
        viewProteinBottom.dropShadow()
        
        buttonHapus.layer.cornerRadius = 15
    }
    
    
    func setData(){
        foodNameLabel.text = self.selectedFood.foodName
        imagePhoto.image = imageHasilPhoto ?? UIImage(named: "breakfast")
        labelKaloriValueTop.text = String(self.selectedFood.foodCalories) + "kal"
        labelLemakValueTop.text = String(self.selectedFood.foodFat) + "gr"
        labelKarbohidratValueTop.text = String(self.selectedFood.foodCarbohydrate) + "gr"
        labelProteinValueTop.text = String(self.selectedFood.foodProtein) + "gr"

        labelKaloriValueBottom.text = String(self.selectedFood.foodCalories) + "kal"
         labelLemakValueBottom.text = String(self.selectedFood.foodFat) + "gr"
         labelKarbohidratValueBottom.text = String(self.selectedFood.foodCarbohydrate) + "gr"
         labelProteinValueBottom.text = String(self.selectedFood.foodProtein) + "gr"
    }
    
    /*@IBAction func buttonSubmit_Pressed(_ sender: Any) {
        if (selectedReason != "" || selectedTime != "" || selectedFeel != ""){
            // get nilai2 tersebut ke dalam CoreData
            print(selectedFeel ?? "")
            print(selectedTime ?? "")
            print(selectedReason ?? "")
            getSelectedDataIntoCoreData(time: selectedTime ?? "", feel: selectedFeel ?? "", reason: selectedReason ?? "")
            
            /*let storyboard = UIStoryboard(name: "JournalViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "JournalViewController") as! JournalViewController
            navigationController?.pushViewController(vc, animated: true)*/
        }
        else{
            print("Kosong!")
        }
    }*/
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToHome"){
            let vc = segue.destination as? HomeTabBar
            vc?.modalPresentationStyle = .fullScreen
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collectionView.backgroundColor = UIColor.green
        //collectionView.layer.backgroundColor = CGColor.init(red: 0, green: 255, blue: 0, alpha: 1)
        if collectionView == self.timeToEatCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! TimeToEatCollectionViewCell
            cell.changeUpdate()
            let time = timeToEatArray[indexPath.item]
            selectedTime = time 
            print(selectedTime ?? "")
        } else if collectionView == self.reasonToEatCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! ReasonToEatCollectionViewCell
            cell.changeUpdate()
            let reason = reasonToEatArray[indexPath.item]
            selectedReason = reason
            print(selectedReason ?? "")
        } else if collectionView == self.feelWhenEatCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! FeelToEatCollectionViewCell
            cell.changeUpdate()
            let feel = feelWhenEatArray[indexPath.item]
            selectedFeel = feel
            print(selectedFeel ?? "")
        } else{
            selectedTime = ""
            selectedReason = ""
            selectedFeel = ""
        }
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//
//        let totalCellWidth = CellWidth * CellCount
//        let totalSpacingWidth = CellSpacing * (CellCount - 1)
//
//        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return porsiMakanan.count
        }
        return satuanPorsi.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            
            return String(porsiMakanan[row])
        }
        return satuanPorsi[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if pickerView == self.porsiPickerView {
           
                selectedPorsi = porsiMakanan[row]
         
                selectedSatuan =  satuanPorsi[0]
        }

    }
    
    func getSelectedDataIntoCoreData(time: String, feel: String, reason: String){
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
        food.setValue(detailFood?.foodSodium, forKeyPath: "foodSodium")
        food.setValue(detailFood?.foodSaturatedFat, forKeyPath: "foodSaturatedFat")
        food.setValue(time, forKeyPath: "timeTaken")
        food.setValue(reason, forKeyPath: "eatCause")
        food.setValue(feel, forKeyPath: "eatFeeling")
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        //print("tanggal hari ini : \(formattedDate)")
        food.setValue(formattedDate, forKeyPath: "dateTaken")
        //food.setValue(imageHasilPhoto.toPngString(), forKeyPath: "foodPhoto")
        food.setValue(imageHasilPhoto.pngData(), forKeyPath: "foodPhoto")
        do{
            try managedContext.save()
            print("Data save!")
        }catch let error as NSError{
            print("Error! \(error) \(error.userInfo)")
        }
    }
}

/*extension Date{
    func dateToString(d: Date) -> String{
        let formatter = DateFormatter()
        return formatter.string(from: d)
    }
}*/
extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
