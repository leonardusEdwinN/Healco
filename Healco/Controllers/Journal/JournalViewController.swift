//
//  JournalViewController.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 15/06/21.
//

import Foundation
import CoreData
import UIKit
import FatSecretSwift

enum isJournalFill {
    case yesterdayFill //jika jurnal terisi
    case yesterdayNo //jika journal tidak terisi
    case dayDate //untuk tanggal hari ini
    case tomorrow
}

class JournalViewController : UIViewController{
    
    //Coredata
    let data = CoreDataClass()
    
    let fatSecretClient = FatSecretClient()
    var selectedFood = FoodModel2()
    
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
    @IBOutlet weak var stackViewNoSarapan: UIStackView!
    @IBOutlet weak var labelNoSarapan: UILabel!
    @IBOutlet weak var imageNoSarapan: UIImageView!
    @IBOutlet weak var labelSarapan: UILabel!
    @IBOutlet weak var collectionViewSarapan: UICollectionView!
    //CollectionView Makan Siang
    @IBOutlet weak var viewMakanSiang: UIView!
    @IBOutlet weak var stackViewNoMakanSiang: UIStackView!
    @IBOutlet weak var labelNoMakanSiang: UILabel!
    @IBOutlet weak var imageNoMakanSiang: UIImageView!
    @IBOutlet weak var labelMakanSiang: UILabel!
    @IBOutlet weak var collectionViewMakanSiang: UICollectionView!
    //CollectionView Makan Malem
    @IBOutlet weak var viewMakanMalam: UIView!
    @IBOutlet weak var stackViewNoMakanMalam: UIStackView!
    @IBOutlet weak var labelNoMakanMalam: UILabel!
    @IBOutlet weak var imageNoMakanMalam: UIImageView!
    @IBOutlet weak var labelMakanMalam: UILabel!
    @IBOutlet weak var collectionViewMakanMalam: UICollectionView!
    //CollectionView Snack
    @IBOutlet weak var viewSnack: UIView!
    @IBOutlet weak var stackViewNoSnack: UIStackView!
    @IBOutlet weak var labelNoSnack: UILabel!
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
    var isInitiateDate : Bool = false
    var selectedIndex : Int = 0
    
    //properties
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    let numberOfItemsPerRow: CGFloat = 4
    let spacingBetweenCells: CGFloat = 10
    private var startingScrollingOffset = CGPoint.zero
    
    var datePicker  = UIDatePicker()
    var tanggalHariIni : Date!
    let formatter = DateFormatter()
    
    var fetchData: [NSManagedObject] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionViewSnack.reloadData()
        collectionViewSarapan.reloadData()
        collectionViewMakanSiang.reloadData()
        collectionViewMakanMalam.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getWidthViewNutrition()
        self.getDateArray()
        self.createUI()
        
        // MARK: FOR BMR
        tanggalHariIni = getTodayDate()
        
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
        
        let bmr = BMR(profile: profileDummy)
        
        let kaloriHariIni : Float = Float(sumkalori)
        let persentageBmr : Float = kaloriHariIni  / Float(bmr)
        
        //MARK: CHANGE FRONT END DATA
        labelKalori.text = "\(Int(kaloriHariIni)) /\(bmr)"
        labelKarbohidratValue.text = "\(data.getPercentage(macroNutrient: .karbohidrat, tanggalJurnal: tanggalHariIni))"
        labelProteinValue.text = "\(data.getPercentage(macroNutrient: .protein, tanggalJurnal: getTodayDate()))"
        labelLemakValue.text = "\(data.getPercentage(macroNutrient: .lemak, tanggalJurnal: tanggalHariIni))"
        
        progressViewKalori.setProgress( persentageBmr , animated: true)
        
        
        let tanggal = Date()
        let calendar = Calendar.current
        let tanggalBaru = calendar.dateComponents([.year, .month, .day], from: tanggal as Date)

        guard let tanggalJurnal = calendar.date(from: tanggalBaru) else { return }
        print("DATE TANGGAL JURNAL : \(tanggalJurnal)")
//
        getJournal(tanggal: tanggalHariIni)
        
//        collectionViewSarapan.reloadData()
//        collectionViewMakanSiang.reloadData()
//        collectionViewMakanMalam.reloadData()
//        collectionViewSnack.reloadData()

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
    
    func getDateArray() {
        let theCalendar     = Calendar.current
        var dayComponent    = DateComponents()
        dayComponent.day    = 1 // For removing one day (yesterday): -1
        
        let calendarDate = Date()
        
        var tanggal : Date?
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        for indexOfDate in 0..<7 {
            
            if (indexOfDate == 0) {
                tanggal = calendarDate.startOfWeek
            }
            formatter.dateFormat = "dd"
//            formatter.locale = Locale(identifier: "id_ID")
            let tanggalPrint = formatter.string(from: tanggal!)
            date.append(tanggalPrint)
            
            tanggal = theCalendar.date(byAdding: dayComponent, to: tanggal!) //tambahin lagi 1 hari
        }
    }
    
    func getFoodJournalIsEmptyOrNay(tanggalParam : Date) -> isJournalFill{
        var result : isJournalFill = .tomorrow
        let dataJournal = data.fetchJournalBaseOnDay(tanggalWaktu: tanggalParam)
        let order = Calendar.current.compare(tanggalHariIni, to: tanggalParam, toGranularity: .day)
        
        switch order {
        case .orderedDescending: //yesterday
            result =  dataJournal.count > 0 ? isJournalFill.yesterdayFill : isJournalFill.yesterdayNo
        case .orderedAscending: //tomorrow
            result = isJournalFill.tomorrow
        case .orderedSame: //daydate
            result = isJournalFill.dayDate
        }
        
        return result
    }
    
    func getJournal(tanggal: Date){
        print("DATE : \(tanggal)")
        let dataJournalSarapan = data.fetchJournalBaseOnDayAndType(tanggalWaktu: tanggal, tipe: "Breakfast")
        stackViewNoSarapan.isHidden = dataJournalSarapan.count > 0 ? true : false
        self.dataJournalSarapan = dataJournalSarapan.count > 0 ? dataJournalSarapan : []
        self.collectionViewSarapan.reloadData()
        
        let dataJournalSiang = data.fetchJournalBaseOnDayAndType(tanggalWaktu: tanggal, tipe: "Lunch")
        stackViewNoMakanSiang.isHidden = dataJournalSiang.count > 0 ? true : false
        self.dataJournalMakanSiang = dataJournalSiang.count > 0 ? dataJournalSiang : []
        self.collectionViewMakanSiang.reloadData()
        
        let dataJournalMalam = data.fetchJournalBaseOnDayAndType(tanggalWaktu: tanggal, tipe: "Dinner")
        stackViewNoMakanMalam.isHidden = dataJournalMalam.count > 0 ? true : false
        self.dataJournalMakanMalam = dataJournalMalam.count > 0 ? dataJournalMalam : []
        self.collectionViewMakanMalam.reloadData()
        
        let dataJournalSnack = data.fetchJournalBaseOnDayAndType(tanggalWaktu: tanggal, tipe: "Snack")
        stackViewNoSnack.isHidden = dataJournalSnack.count > 0 ? true : false
        self.dataJournalSnack = dataJournalSnack.count > 0 ? dataJournalSnack : []
        self.collectionViewSnack.reloadData()
        
        print("JOURNAL SARAPAN : \(self.dataJournalSarapan.count)")
        print("JOURNAL SIANG : \(self.dataJournalMakanSiang.count)")
        print("JOURNAL MALAM : \(self.dataJournalMakanMalam.count)")
        print("JOURNAL SNACK : \(self.dataJournalSnack.count)")
        
        
        
//        for journal in data.fetchJournal() {
//            print("tipe: ", journal.tipe ?? "")
//            print("karbo: ", journal.karbohidratTotal)
//            print("lemak: ", journal.lemakTotal)
//            print("protein: ", journal.proteinTotal)
//            print("kalori: ", journal.kaloriTotal)
//        }
//
//        print("data jurnal: ", data.fetchJournal().count)
    }
    
    func calcAge(birthday: Date) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthday, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    @objc func backgroundTap(gesture : UITapGestureRecognizer) {
        datePicker.removeFromSuperview()
    }
    
    @IBAction func buttonChangeDateClicked(_ sender: UIButton) {
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
        datePicker.removeFromSuperview()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        if let date = sender?.date {
            self.selectedDate = dateFormatter.string(from: date)
            datePicker.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailJournal",
           let detailJournalVC = segue.destination as? FoodDetailViewController {
            detailJournalVC.statusEdit = true
            detailJournalVC.selectedFood = self.selectedFood
            detailJournalVC.modalPresentationStyle = .fullScreen
            
        }
    }
}

extension JournalViewController : UICollectionViewDataSource{
    
    //retrive image
    private func retrieveImage(forKey key: String, inStorageType storageType: StorageType) -> UIImage {
        switch storageType {
            case .fileSystem:
                // Retrieve image from disk
                break
            case .userDefaults:
                if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                    let image = UIImage(data: imageData) {
                    
                    return image
                }
        }
        return UIImage(named: "brooke-lark-nBtmglfY0HU-unsplash")!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewWeekly {
            return 7
        } else if collectionView == self.collectionViewSarapan {
            return self.dataJournalSarapan.count
        } else if collectionView == self.collectionViewMakanSiang {
            return self.dataJournalMakanSiang.count
        } else if collectionView == self.collectionViewMakanMalam {
            return self.dataJournalMakanMalam.count
        } else if collectionView == self.collectionViewSnack {
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
            
            if (tanggalCell == date[indexPath.item]){
                cell.setUI(dateText: date[indexPath.item], dayString: dayString[indexPath.item],isToday: true)
                self.isInitiateDate = true
                self.selectedIndex = indexPath.item
            } else {
                cell.setUI(dateText: date[indexPath.item], dayString: dayString[indexPath.item],isToday: false)
            }
            
            let tanggal = Date()
            let calendar = Calendar.current
            var tanggalBaru = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: tanggal as Date)
            tanggalBaru.day = Int(date[indexPath.item])
            
            if let tanggalParam = calendar.date(from: tanggalBaru){
                switch getFoodJournalIsEmptyOrNay(tanggalParam: tanggalParam) {
                case isJournalFill.yesterdayNo:
                    cell.labelTanggal.backgroundColor = UIColor(named : "StateUnactiveText")
                    cell.labelTanggal.textColor = .black
                case isJournalFill.yesterdayFill:
                    cell.labelTanggal.backgroundColor = UIColor(named : "AvocadoGreen")
                    cell.labelTanggal.textColor = .white
                case isJournalFill.dayDate:
                    cell.labelTanggal.backgroundColor = UIColor(named : "MangoYoghurt")
                    cell.labelTanggal.textColor = .black
                default:
                    cell.labelTanggal.backgroundColor = .secondarySystemBackground
                    cell.labelTanggal.textColor = .label
                }
            }
        
            cell.changeUpdate()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryPhotoCell", for: indexPath) as! GalleryPhotoCollectionViewCell
            
            if collectionView == self.collectionViewSarapan {
                if (self.dataJournalSarapan.count > 0){
                    cell.setUI(dataPhoto: retrieveImage(forKey: self.dataJournalSarapan[indexPath.item].gambar! , inStorageType: .userDefaults) , title: self.dataJournalSarapan[indexPath.item].nama ?? "")
                }

            }else  if collectionView == self.collectionViewMakanSiang {
                if (self.dataJournalMakanSiang.count > 0){
                    cell.setUI(dataPhoto: retrieveImage(forKey: self.dataJournalMakanSiang[indexPath.item].gambar! , inStorageType: .userDefaults) , title: self.dataJournalMakanSiang[indexPath.item].nama ?? "")
                }
            }else  if collectionView == self.collectionViewMakanMalam {
                if(self.dataJournalMakanMalam.count > 0){
                    cell.setUI(dataPhoto: retrieveImage(forKey: self.dataJournalMakanMalam[indexPath.item].gambar! , inStorageType: .userDefaults) , title: self.dataJournalMakanMalam[indexPath.item].nama ?? "")
                }
                
            }else  if collectionView == self.collectionViewSnack {
                if(self.dataJournalSnack.count > 0){
                    cell.setUI(dataPhoto: retrieveImage(forKey: self.dataJournalSnack[indexPath.item].gambar! , inStorageType: .userDefaults) , title: self.dataJournalSnack[indexPath.item].nama!)
                }
            }
            return cell

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.collectionViewWeekly:
            let cell = collectionView.cellForItem(at: indexPath) as! WeeklyCollectionViewCell
            
            if(self.isInitiateDate){
                let cellSelectedBefore = collectionView.cellForItem(at: IndexPath(item: self.selectedIndex, section: 0)) as! WeeklyCollectionViewCell
                
                cellSelectedBefore.isSelected = false
                
                self.isInitiateDate = false
                cellSelectedBefore.changeUpdate()
            }
            
            cell.changeUpdate()
            
            let tanggal = Date()
            let calendar = Calendar.current
            var tanggalBaru = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: tanggal as Date)
            tanggalBaru.day = Int(date[indexPath.item])
            
            guard let tanggalJurnal = calendar.date(from: tanggalBaru) else { return }
            
            getJournal(tanggal: tanggalJurnal)
            
            break
        case self.collectionViewSarapan:
            if let foodIdSelected = dataJournalSarapan[indexPath.item].id_meal, let gambar = dataJournalSarapan[indexPath.item].gambar{
                getFood(idFood : foodIdSelected, gambar : gambar)
            }
            break
        case self.collectionViewMakanSiang:
            print("SOMETHING CLICKED FROM SIANG")
            print("selected \(dataJournalMakanSiang[indexPath.item])")
            if let foodIdSelected = dataJournalMakanSiang[indexPath.item].id_meal , let gambar = dataJournalMakanSiang[indexPath.item].gambar{
                getFood(idFood : foodIdSelected, gambar : gambar)
            }
            break
        case self.collectionViewMakanMalam:
            if let foodIdSelected = dataJournalMakanMalam[indexPath.item].id_meal , let gambar = dataJournalMakanMalam[indexPath.item].gambar{
                getFood(idFood : foodIdSelected, gambar : gambar)
            }
            break
        case self.collectionViewSnack:
            print("selected \(dataJournalSnack[indexPath.item])")
            if let foodIdSelected = dataJournalSnack[indexPath.item].id_meal, let gambar = dataJournalSnack[indexPath.item].gambar{
                getFood(idFood : foodIdSelected, gambar : gambar)
            }
            break
        default:
            print("CANNOT SELECT")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewWeekly {
            (collectionView.cellForItem(at: indexPath) as! WeeklyCollectionViewCell).changeUpdate()
        }
    }
    
    // MARK: BMR Calculation
    
    private func BMR(profile : Profile) -> Int{
        var bmrScore : Float!
        let weight : Float = Float(profile.weight)
        let height : Float = Float(profile.height)
        let age : Float = Float(profile.age)
        
        if profile.gender == .male {
            bmrScore = 88.362 + 13.397 * weight  + 4.799 * height  - 5.677 * age
        } else {
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
        } else {
            widthCell =  CGSize(width: 125 , height:150)
        }
        
        return widthCell
    }
}

extension JournalViewController : UICollectionViewDelegate, UIScrollViewDelegate{
    
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
        progressViewKalori.layer.borderWidth = 0.5
        progressViewKalori.layer.borderColor = UIColor(named : "AvocadoGreen")?.cgColor
        progressViewKalori.layer.cornerRadius = 5
        
        //weekly
        collectionViewWeekly.register(UINib.init(nibName: "WeeklyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "weeklyCollectionViewCell")
        collectionViewWeekly.delegate = self
        collectionViewWeekly.dataSource = self
        collectionViewWeekly.allowsMultipleSelection = false
        
        //sarapan
        collectionViewSarapan.register(UINib.init(nibName: "GalleryPhotoCollectionViewCell", bundle: nil),
                                       forCellWithReuseIdentifier: "galleryPhotoCell")
        collectionViewSarapan.delegate = self
        collectionViewSarapan.dataSource = self
        collectionViewMakanSiang.register(UINib.init(nibName: "GalleryPhotoCollectionViewCell", bundle: nil),
                                          forCellWithReuseIdentifier: "galleryPhotoCell")
        collectionViewMakanSiang.delegate = self
        collectionViewMakanSiang.dataSource = self
        collectionViewMakanMalam.register(UINib.init(nibName: "GalleryPhotoCollectionViewCell", bundle: nil),
                                          forCellWithReuseIdentifier: "galleryPhotoCell")
        collectionViewMakanMalam.delegate = self
        collectionViewMakanMalam.dataSource = self
        collectionViewSnack.register(UINib.init(nibName: "GalleryPhotoCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "galleryPhotoCell")
        collectionViewSnack.delegate = self
        collectionViewSnack.dataSource = self
        
        stackViewNoSarapan.isHidden = true
        stackViewNoMakanSiang.isHidden = true
        stackViewNoMakanMalam.isHidden = true
        stackViewNoSnack.isHidden = true
    }
    
    func getWidthViewNutrition(){
        let width = UIScreen.main.bounds.size.width
        let rightLeftInset = 60 // (left : 20, right : 20, jarak : 10*2)
        
        let calculate = (Int(width) - rightLeftInset) / 3
        Swift.print("caclulate width : \(calculate)")
        self.viewKarbohidrat.frame.size.width = CGFloat(calculate)
        self.viewProtein.frame.size.width = CGFloat(calculate)
        self.viewLemak.frame.size.width = CGFloat(calculate)
    }
}

extension JournalViewController{
    func getFood(idFood : String, gambar : String){
        fatSecretClient.getFood(id: idFood) { food in
            guard let servingsFood = food.servings?[0] else { return }
            
            
//            let data = FoodModel2(foodName: food.name, foodDescription: "", foodCalories: Double(servingsFood.calories ?? "0.0") ?? 0.0 , foodFat: Double(servingsFood.fat ?? "0.0") ?? 0.0, foodCarbohydrate: Double(servingsFood.carbohydrate ?? "0.0") ?? 0.0, foodProtein: Double(servingsFood.protein ?? "0.0") ?? 0.0, foodSodium: Double(servingsFood.sodium ?? "0.0") ?? 0.0, foodStatus: "", foodSaturatedFat: Double(servingsFood.saturatedFat ?? "0.0") ?? 0.0, foodId: idFood)
//
//            let foodStatus = self.calculateFood(foodModel: data).rawValue
//            var description = ""
            
            
            self.selectedFood = FoodModel2(foodName: food.name, foodDescription: "", foodCalories: Double(servingsFood.calories ?? "0.0") ?? 0.0 , foodFat: Double(servingsFood.fat ?? "0.0") ?? 0.0, foodCarbohydrate: Double(servingsFood.carbohydrate ?? "0.0") ?? 0.0, foodProtein: Double(servingsFood.protein ?? "0.0") ?? 0.0, foodSodium: Double(servingsFood.sodium ?? "0.0") ?? 0.0, foodStatus: "", foodSaturatedFat: Double(servingsFood.saturatedFat ?? "0.0") ?? 0.0, foodId: idFood, foodImage : gambar)
            
            
            //print("DATA SELECTED FOOD : \(self.selectedFood)")
            DispatchQueue.main.async {
//                let storyboard = UIStoryboard(name: "FoodDetail", bundle: nil);
//                let vc = storyboard.instantiateViewController(withIdentifier: "FoodDetailViewController") as! FoodDetailViewController
//                vc.selectedFood = self.selectedFood
//                vc.statusEdit = true
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true, completion: nil)
                self.performSegue(withIdentifier: "goToDetailJournal", sender: self)
            }
        }
        
        
    }
}
