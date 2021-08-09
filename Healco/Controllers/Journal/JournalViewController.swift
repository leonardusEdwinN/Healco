//
//  JournalViewController.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 15/06/21.
//

import Foundation
//import Charts
import CoreData
import UIKit



class JournalViewController : UIViewController{
    
    //coredata
    let data = CoreDataClass()
    
    var profile : Profile!
    
    @IBOutlet weak var viewScrolling: UIView!
    
    @IBOutlet weak var addJournalButton: UIButton!
    //Header
    @IBOutlet weak var viewJournalHeader: UIView!
    @IBOutlet weak var labelJournalTitle: UILabel!
    @IBOutlet weak var labelBulan: UILabel!
    @IBOutlet weak var buttonChangeDate: UIButton!
    
    //Weekly CollectionView
    @IBOutlet weak var collectionViewWeekly: UICollectionView!
    
    //Nutrisi hari ini
    @IBOutlet weak var labelNutrisiHariIni: UILabel!
    @IBOutlet weak var viewKalori: UIView!
    @IBOutlet weak var labelKaloriText: UILabel!
    @IBOutlet weak var labelKalori: UILabel!
    @IBOutlet weak var labelSatuanKalori: UILabel!
    @IBOutlet weak var progressViewKalori: UIProgressView!
    
    //Karbohidrat
    @IBOutlet weak var labelKarbohidratValue: UILabel!
    @IBOutlet weak var labelKarbohidratText: UILabel!
    @IBOutlet weak var viewKarbohidrat: UIView!
    //Protein
    @IBOutlet weak var labelProteinValue: UILabel!
    @IBOutlet weak var labelProteinText: UILabel!
    @IBOutlet weak var viewProtein: UIView!
    //Lemak
    @IBOutlet weak var labelLemakValue: UILabel!
    @IBOutlet weak var labelLemakText: UILabel!
    @IBOutlet weak var viewLemak: UIView!
    
    //Konsumsimu Hari Ini
    @IBOutlet weak var labelKonsumsimuHariIni: UILabel!
    //CollectionView Sarapan
    @IBOutlet weak var viewSarapan: UIView!
    @IBOutlet weak var imageNoSarapan: UIImageView!
    @IBOutlet weak var labelSarapan: UILabel!
    @IBOutlet weak var collectionViewSarapan: UICollectionView!
    //CollectionView Makan Siang
    @IBOutlet weak var viewMakanSiang: UIView!
    @IBOutlet weak var imageNoMakanSiang: UIImageView!
    @IBOutlet weak var labelMakanSiang: UILabel!
    @IBOutlet weak var collectionViewMakanSiang: UICollectionView!
    //CollectionView Makan Malem
    @IBOutlet weak var viewMakanMalam: UIView!
    @IBOutlet weak var imageNoMakanMalam: UIImageView!
    @IBOutlet weak var labelMakanMalam: UILabel!
    @IBOutlet weak var collectionViewMakanMalam: UICollectionView!
    //CollectionView Snack
    @IBOutlet weak var viewSnack: UIView!
    @IBOutlet weak var imageNoSnack: UIImageView!
    @IBOutlet weak var labelSnack: UILabel!
    @IBOutlet weak var collectionViewSnack: UICollectionView!
    
    
    //data Journal Array
    var dataJournalSarapan : [JournalEntity] = [JournalEntity]()
    var dataJournalMakanSiang : [JournalEntity] = [JournalEntity]()
    var dataJournalMakanMalam : [JournalEntity] = [JournalEntity]()
    var dataJournalSnack : [JournalEntity] = [JournalEntity]()
    
    // Weekly CollectionCell
    var date : [String] = []
    var dayString : [String] = ["Min", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"]
    var dateForDataBase : [String] = []
    var selectedBefore : IndexPath!
    var selectedDate : String = ""
    
    //properties
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    let numberOfItemsPerRow: CGFloat = 4
    let spacingBetweenCells: CGFloat = 10
    private var startingScrollingOffset = CGPoint.zero
    
    //datepicker
//    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    let tanggalHariIni = Date()
    let formatter = DateFormatter()
    
    var fetchData: [NSManagedObject] = []
    
//    //create imagepicker viewcontroller
//    private var imagePickerControler =  UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getWidthViewNutrition()
        self.getDateArray()
        self.createUI()
        
        
        // MARK: FOR BMR
        let profileDataFetch = data.fetchProfile()
        let sumkalori = data.sumKalori(tanggalJurnal: tanggalHariIni)
        var profileDummy : Profile = Profile(age: 0, gender: .male, height: 0, weight: 0)
        
        if profileDataFetch.count != 0{
            profileDummy.age = calcAge(birthday: profileDataFetch[0].tanggal_lahir ?? Date())


            profileDummy.gender = profileDataFetch[0].gender == "Pria" || profileDataFetch[0].gender == "" ? .male : .female
        
            profileDummy.height = Int(profileDataFetch[0].tinggi_badan)
        
            profileDummy.weight = profileDataFetch[0].berat_badan
        
        } else {
            profileDummy = Profile(age: 0, gender: .male, height: 0, weight: 0)
        }
        
//        print("\(profileDummy.weight = profileDataFetch[0].berat_badan)")
        let bmr = BMR(profile: profileDummy)
        
        let kaloriHariIni : Float = Float(sumkalori)
        
        let persentageBmr : Float = kaloriHariIni  / Float(bmr)
        
        //MARK: CHANGE FRONT END DATA CALORI
        labelKalori.text = "\(Int(kaloriHariIni)) /\(bmr)"
        progressViewKalori.setProgress( persentageBmr , animated: true)
        
        
        getJournal(tanggal: tanggalHariIni)

    }
    
    func getJournal(tanggal : Date){
        
        print("Tanggal : \(tanggal)")
        let tanggalFormat = formatter.date(from: "\(tanggal)")
        
        print("Tanggal : \(formatter.dateFormat = "YYYY-MM-DD")")
        
        let dataJournalSarapan = data.fetchJournalBaseOnDayAndType(tanggalWaktu: tanggal, tipe: "Sarapan")
        imageNoSarapan.isHidden = dataJournalSarapan.count > 0 ? true : false
        self.dataJournalSarapan = dataJournalSarapan.count > 0 ? dataJournalSarapan : []
       
        let dataJournalSiang = data.fetchJournalBaseOnDayAndType(tanggalWaktu: tanggal, tipe: "Siang")
        imageNoMakanSiang.isHidden = dataJournalSiang.count > 0 ? true : false
        self.dataJournalMakanSiang = dataJournalSiang.count > 0 ? dataJournalSiang : []
        
        let dataJournalMalam = data.fetchJournalBaseOnDayAndType(tanggalWaktu: tanggal, tipe: "Malam")
        imageNoMakanMalam.isHidden = dataJournalMalam.count > 0 ? true : false
        self.dataJournalMakanMalam = dataJournalMalam.count > 0 ? dataJournalMalam : []
        
        let dataJournalSnack = data.fetchJournalBaseOnDayAndType(tanggalWaktu: tanggal, tipe: "Snack")
        imageNoSnack.isHidden = dataJournalSnack.count > 0 ? true : false
        self.dataJournalSnack = dataJournalSnack.count > 0 ? dataJournalSnack : []
        
        print("DATA JOURNAL : \(dataJournalSarapan)")
        print("DATA JOURNAL : \(dataJournalSiang)")
        print("DATA JOURNAL : \(dataJournalMalam)")
        print("DATA JOURNAL : \(dataJournalSnack)")
//        if(dataJournalSarapan.count > 0){
//
//        }else{
//            //ketika ga punya data
//        }
    }
    
    
  
    
    func calcAge(birthday: Date) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        // let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthday, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    
    @objc  func backgroundTap(gesture : UITapGestureRecognizer) {
        datePicker.removeFromSuperview()
    }
    
    
    
    
    @IBAction func buttonChangeDateClicked(_ sender: UIButton) {
        
//        datePicker = UIDatePicker.init()
//        datePicker.backgroundColor = UIColor.white
//
//        datePicker.autoresizingMask = .flexibleWidth
//        datePicker.datePickerMode = .date
//
//        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
//        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 150, width: UIScreen.main.bounds.size.width, height: 150)
//        self.view.addSubview(datePicker)
//
//        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 150, width: UIScreen.main.bounds.size.width, height: 50))
//        toolBar.barStyle = .default
//
//        let topBarTitleLabel = UILabel.init(frame: (CGRect.init(origin: CGPoint.init(x: 0.0, y: 0.0), size: CGSize.init(width: 0.0, height: 0.0))))
//        topBarTitleLabel.text = "Change Date"
//        topBarTitleLabel.sizeToFit()
//        topBarTitleLabel.backgroundColor = UIColor.clear
//        topBarTitleLabel.textColor = UIColor.gray
//        topBarTitleLabel.textAlignment = NSTextAlignment.center
//        let topBarButtonItemTitleLabel = UIBarButtonItem.init(customView: topBarTitleLabel)
//
//        let buttonCancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.onCancelButtonClick))
//        let flexibleBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        self.toolBar.setItems([flexibleBarButtonItem, topBarButtonItemTitleLabel, flexibleBarButtonItem, buttonCancel], animated: false)
//        self.toolBar.setNeedsLayout()
//        toolBar.sizeToFit()
//        self.view.addSubview(toolBar)
        
        
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)

        datePicker.backgroundColor = .secondarySystemBackground
        self.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        
        
        
    }
    


    @objc func onDoneButtonClick() {
//        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        if let date = sender?.date {
//            labelDate.text = dateFormatter.string(from: date)
            print("TANGGAL SELECTED : \(dateFormatter.string(from: date))")
            self.selectedDate = dateFormatter.string(from: date)
            datePicker.removeFromSuperview()
//            toolBar.removeFromSuperview()
        }
    }
    
//
//
//    @objc func goToFoodRecog() {
//        performSegue(withIdentifier: "goToFoodRecog", sender: self)
//    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailJournal",
           let detailJournalVC = segue.destination as? FoodDetailViewController {
            detailJournalVC.statusEdit = true
        }
    }
    
    func calweeksDates(when: Int) -> String {
        var  result = ""
        let lastWeekDate = Calendar.current.date(byAdding: .day, value: when, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let lastWeekDateString = dateFormatter.string(from: lastWeekDate)
        result = lastWeekDateString
        return result
    }
    
    func calweeksDates2(when : Int) -> String {
        var  result = ""
        let lastWeekDate = Calendar.current.date(byAdding: .day, value: when, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = "MMM dd"
        let lastWeekDateString = dateFormatter.string(from: lastWeekDate)
        result = lastWeekDateString
        return result
    }
    
    
}


// MARK : - UICollectionViewDataSource
extension JournalViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewWeekly {
            return 7
        }else  if collectionView == self.collectionViewSarapan {
            return self.dataJournalSarapan.count
        }else  if collectionView == self.collectionViewMakanSiang {
            return self.dataJournalMakanSiang.count
        }else  if collectionView == self.collectionViewMakanMalam {
            return self.dataJournalMakanMalam.count
        }else  if collectionView == self.collectionViewSnack {
            return self.dataJournalSnack.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == self.collectionViewWeekly {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weeklyCollectionViewCell", for: indexPath) as! WeeklyCollectionViewCell
            
            
            formatter.dateFormat = "dd"
            formatter.locale = Locale(identifier: "id_ID")
            let tanggalCell = formatter.string(from: tanggalHariIni)
            
            print("PERBANDINGAN : \(tanggalCell) :: \(date[indexPath.item])")
            tanggalCell == date[indexPath.item] ? print("SAME DATE") : print("WRONG DATE")
            if(tanggalCell == date[indexPath.item]){
//                cell.viewOuter.backgroundColor = .green
                cell.setUI(dateText: date[indexPath.item], dayString: dayString[indexPath.item],isToday: true)
            }else{
                cell.setUI(dateText: date[indexPath.item], dayString: dayString[indexPath.item],isToday: false)
            }
            
//            cell.setUI(dateText: date[indexPath.item], dayString: dayString[indexPath.item])// unteuk set data

            return cell
        }else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryPhotoCell", for: indexPath) as! GalleryPhotoCollectionViewCell
            
            return cell
        }

        return UICollectionViewCell()

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let date = Date()
//        let format = DateFormatter()
//        format.dateFormat = "yyyy-MM-dd"
//        let formattedDate = format.string(from: date)
//        fetchData = myFetchRequestByDate(date: formattedDate)
        
        switch collectionView {
        case self.collectionViewWeekly:
            let cell = collectionView.cellForItem(at: indexPath) as! WeeklyCollectionViewCell
            print("WEEKLY CELL SELECTED \(indexPath.item)")
            break
        case self.collectionViewSarapan:
            let cell = collectionView.cellForItem(at: indexPath) as! GalleryPhotoCollectionViewCell
            print("SOMETHING CLICKED from sarapan")
            performSegue(withIdentifier: "goToDetailJournal", sender: self)
            break
        case self.collectionViewMakanSiang:
            let cell = collectionView.cellForItem(at: indexPath) as! GalleryPhotoCollectionViewCell
            print("SOMETHING CLICKED FROM SIANG")
            performSegue(withIdentifier: "goToDetailJournal", sender: self)
            break
        case self.collectionViewMakanMalam:
            let cell = collectionView.cellForItem(at: indexPath) as! GalleryPhotoCollectionViewCell
            break
        case self.collectionViewSnack:
            let cell = collectionView.cellForItem(at: indexPath) as! GalleryPhotoCollectionViewCell
            break
        default:
            print("CANNOT SELECT")
        }
//        if collectionView == self.collectionViewWeekly {
//            let cell = collectionView.cellForItem(at: indexPath) as! WeeklyCollectionViewCell
////            cell.changeUpdate()
//        }else{
//            let cell = collectionView.cellForItem(at: indexPath) as! GalleryPhotoCollectionViewCell
//            print("SOMETHING CLICKED")
//            performSegue(withIdentifier: "goToDetailJournal", sender: self)
//        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewWeekly {
            let cell = collectionView.cellForItem(at: indexPath) as! WeeklyCollectionViewCell
        }
    }
    
    //BMR calculation
    private func BMR(profile : Profile) -> Int{
        var bmrScore : Float!
        let weight : Float = Float(profile.weight)
        let height : Float = Float(profile.height)
        let age : Float = Float(profile.age)
        
        if profile.gender == .male {
            bmrScore = 88.362 + 13.397 * weight  + 4.799 * height  - 5.677 * age
        }else{
            bmrScore = 447.593 + 9.247 * weight  + 3.098 * height - 4.330 * age
        }
        return Int(bmrScore ?? 0.0)
    }
    
}

extension JournalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthCell : CGSize = CGSize(width: 100, height: 100)
        if collectionView == self.collectionViewWeekly {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                  layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                  layout.minimumInteritemSpacing = 0
                  layout.minimumLineSpacing = 0
                  layout.invalidateLayout()

                  widthCell =  CGSize(width: self.view.frame.width / 8 , height:70) // Set your item size here
        }else{
            widthCell =  CGSize(width: 125 , height:150)
        }

        return widthCell
    }
}



// MARK : - UICollectionViewDelegate
extension JournalViewController : UICollectionViewDelegate, UIScrollViewDelegate{

}

extension JournalViewController{
    func fetchValueFromCoreData()->[NSManagedObject]{
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
    
    func myFetchRequestByDate(date: String)->[NSManagedObject]
    {
        let moc = UIApplication.shared.delegate as? AppDelegate
        var data: [NSManagedObject] = []
        let myRequest = NSFetchRequest<NSManagedObject>(entityName: "Foods")
        let managedContext = moc!.persistentContainer.viewContext
        myRequest.predicate = NSPredicate(format: "dateTaken CONTAINS[cd] %@", date)
        
        do{
            try data = managedContext.fetch(myRequest)
        } catch let error{
            print(error)
        }
        return data
    }
    
    func getFoodFromCoreDataByName(name: String) -> FoodModel2{
        var food: FoodModel2 = FoodModel2()
        let foodsCoreData: [NSManagedObject] = fetchValueFromCoreData()
        for(i) in foodsCoreData.indices{
            if(name == foodsCoreData[i].value(forKeyPath: "foodName") as! String){
                food.foodName = foodsCoreData[i].value(forKeyPath: "foodName") as? String
                food.foodDescription = foodsCoreData[i].value(forKeyPath: "foodDescription") as? String
                food.foodCalories = foodsCoreData[i].value(forKeyPath: "foodCalories") as? Double
                food.foodFat = foodsCoreData[i].value(forKeyPath: "foodFat") as? Double
                food.foodCarbohydrate = foodsCoreData[i].value(forKeyPath: "foodCarbohydrate") as? Double
                food.foodProtein = foodsCoreData[i].value(forKeyPath: "foodProtein") as? Double
                food.foodSodium = foodsCoreData[i].value(forKeyPath: "foodSodium") as? Double
                food.foodSaturatedFat = foodsCoreData[i].value(forKeyPath: "foodSaturatedFat") as? Double
            }
        }
        return food
    }
    
    func getArrangedDateInOneWeek(){
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        print("Hari: \(today)")
        print("Hari apa: \(dayOfWeek)")
    }
}


//extension to get date
extension JournalViewController{
    func getDateArray(){
        let theCalendar     = Calendar.current
        var dayComponent    = DateComponents()
        dayComponent.day    = 1 // For removing one day (yesterday): -1
        
        let calendarDate = Date()
        print("DATE \(calendarDate)")
        
        var tanggal : Date?
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print("DATA : \(formatter.string(from: calendarDate))")
        for indexOfDate in 0..<7 {
            
            if(indexOfDate == 0) {
                tanggal = calendarDate.startOfWeek
            }
//            print("index : \(indexOfDate) :: TANGGAL : \(tanggal)")
            formatter.dateFormat = "dd"
            formatter.locale = Locale(identifier: "id_ID")
            let tanggalPrint = formatter.string(from: tanggal!)
            date.append(tanggalPrint)

            tanggal = theCalendar.date(byAdding: dayComponent, to: tanggal!)//tambahin lagi 1 hari
        }
    }
}


//extension for UI
extension JournalViewController{
    func createUI(){
        
        //view nutrition
        viewJournalHeader.layer.cornerRadius = 30
        viewKarbohidrat.layer.cornerRadius = 15
        viewKarbohidrat.dropShadow()
        viewProtein.layer.cornerRadius = 15
        viewProtein.dropShadow()
        viewLemak.layer.cornerRadius = 15
        viewLemak.dropShadow()
        viewKalori.layer.cornerRadius = 15
        viewKalori.dropShadow()
        
        //progressbar
        progressViewKalori.transform = progressViewKalori.transform.scaledBy(x: 1, y: 3)
        
        //weekly
        collectionViewWeekly.register(UINib.init(nibName: "WeeklyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "weeklyCollectionViewCell")
        collectionViewWeekly.delegate = self
        collectionViewWeekly.dataSource = self
        collectionViewWeekly.allowsMultipleSelection = false
        
        //sarapan
        collectionViewSarapan.register(UINib.init(nibName: "GalleryPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "galleryPhotoCell")
        collectionViewSarapan.delegate = self
        collectionViewSarapan.dataSource = self
        collectionViewMakanSiang.register(UINib.init(nibName: "GalleryPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "galleryPhotoCell")
        collectionViewMakanSiang.delegate = self
        collectionViewMakanSiang.dataSource = self
        collectionViewMakanMalam.register(UINib.init(nibName: "GalleryPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "galleryPhotoCell")
        collectionViewMakanMalam.delegate = self
        collectionViewMakanMalam.dataSource = self
        collectionViewSnack.register(UINib.init(nibName: "GalleryPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "galleryPhotoCell")
        collectionViewSnack.delegate = self
        collectionViewSnack.dataSource = self
        
        imageNoSarapan.isHidden = true
        imageNoMakanSiang.isHidden = true
        imageNoMakanMalam.isHidden = true
        imageNoSnack.isHidden = true
    }
    
    func getWidthViewNutrition(){
        let width = UIScreen.main.bounds.size.width
        let rightLeftInset = 60 //(left : 20, right : 20, jarak : 10*2)
        
        let calculate = (Int(width) - rightLeftInset) / 3
        Swift.print("caclulate width : \(calculate)")
        self.viewKarbohidrat.frame.size.width = CGFloat(calculate)
        self.viewProtein.frame.size.width = CGFloat(calculate)
        self.viewLemak.frame.size.width = CGFloat(calculate)
    }
}
