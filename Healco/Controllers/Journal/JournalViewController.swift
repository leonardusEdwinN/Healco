//
//  JournalViewController.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 15/06/21.
//

import Foundation
import Charts
import CoreData

class JournalViewController : UIViewController{
    
    
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
    @IBOutlet weak var labelSarapan: UILabel!
    @IBOutlet weak var collectionViewSarapan: UICollectionView!
    //CollectionView Makan Siang
    @IBOutlet weak var labelMakanSiang: UILabel!
    @IBOutlet weak var collectionViewMakanSiang: UICollectionView!
    //CollectionView Makan Malem
    @IBOutlet weak var labelMakanMalam: UILabel!
    @IBOutlet weak var collectionViewMakanMalam: UICollectionView!
    //CollectionView Snack
    @IBOutlet weak var labelSnack: UILabel!
    @IBOutlet weak var collectionViewSnack: UICollectionView!
    
    // Weekly CollectionCell
    var date : [String] = []
    var dateForDataBase : [String] = []
    var selectedBefore : IndexPath!
    
    //properties
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    let numberOfItemsPerRow: CGFloat = 4
    let spacingBetweenCells: CGFloat = 10
    private var startingScrollingOffset = CGPoint.zero
    
    //datepicker
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    
    var fetchData: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewJournalHeader.layer.cornerRadius = 30
        viewKarbohidrat.layer.cornerRadius = 15
        viewKarbohidrat.dropShadow()
        viewProtein.layer.cornerRadius = 15
        viewProtein.dropShadow()
        viewLemak.layer.cornerRadius = 15
        viewLemak.dropShadow()
        viewKalori.layer.cornerRadius = 15
        viewKalori.dropShadow()
        
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
        
        let calendarDate = Date.today()
        print("DATE \(calendarDate)")
        
        let weekday = Calendar.current.component(.weekday, from: Date())
        print("weekday : \(weekday)")
//        for n in (1...weekday - 1).reversed(){
//            date.append(calweeksDates2(when: -n))
//            dateForDataBase.append(calweeksDates(when: -n))
//            print(-n)
//        }
//        date.append(calweeksDates2(when: 0))
//        dateForDataBase.append(calweeksDates(when: 0))
//        for n in weekday - 1...5{
//            date.append(calweeksDates2(when: n))
//            dateForDataBase.append(calweeksDates(when: n))
//            print(n)
//        }
//
//        let date = Date()
//        let format = DateFormatter()
//        format.dateFormat = "yyyy-MM-dd"
//        let formattedDate = format.string(from: date)
//        print("FORMATTED DATE : \(formattedDate)")
//        fetchData = myFetchRequestByDate(date: formattedDate)
    }
    
    
    
    @IBAction func buttonChangeDateClicked(_ sender: UIButton) {
        
        datePicker = UIDatePicker.init()
        datePicker.backgroundColor = UIColor.white
        
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 150, width: UIScreen.main.bounds.size.width, height: 150)
        self.view.addSubview(datePicker)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 150, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        
        let topBarTitleLabel = UILabel.init(frame: (CGRect.init(origin: CGPoint.init(x: 0.0, y: 0.0), size: CGSize.init(width: 0.0, height: 0.0))))
        topBarTitleLabel.text = "Change Date"
        topBarTitleLabel.sizeToFit()
        topBarTitleLabel.backgroundColor = UIColor.clear
        topBarTitleLabel.textColor = UIColor.gray
        topBarTitleLabel.textAlignment = NSTextAlignment.center
        let topBarButtonItemTitleLabel = UIBarButtonItem.init(customView: topBarTitleLabel)
        
        let buttonCancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.onCancelButtonClick))
        let flexibleBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        self.toolBar.setItems([flexibleBarButtonItem, topBarButtonItemTitleLabel, flexibleBarButtonItem, buttonCancel], animated: false)
        self.toolBar.setNeedsLayout()
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
    }
    
    @objc func onCancelButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        if let date = sender?.date {
//            labelDate.text = dateFormatter.string(from: date)
            datePicker.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
    }
    
    @objc func goToFoodRecog() {
        performSegue(withIdentifier: "goToFoodRecog", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFoodRecog",
           let foodRecogVC = segue.destination as? FoodRecogVC {
            foodRecogVC.modalPresentationStyle = .fullScreen
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
            return 6
        }else  if collectionView == self.collectionViewSarapan {
            return 5
        }else  if collectionView == self.collectionViewMakanSiang {
            return 1
        }else  if collectionView == self.collectionViewMakanMalam {
            return 2
        }else  if collectionView == self.collectionViewSnack {
            return 3
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == self.collectionViewWeekly {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weeklyCollectionViewCell", for: indexPath) as! WeeklyCollectionViewCell
            
//            cell.setUI(dateText: date[indexPath.item])

            return cell
        }else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryPhotoCell", for: indexPath) as! GalleryPhotoCollectionViewCell
            
            return cell
        }

        return UICollectionViewCell()

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        fetchData = myFetchRequestByDate(date: formattedDate)
        if collectionView == self.collectionViewWeekly {
            let cell = collectionView.cellForItem(at: indexPath) as! WeeklyCollectionViewCell
//            cell.changeUpdate()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewWeekly {
            let cell = collectionView.cellForItem(at: indexPath) as! WeeklyCollectionViewCell
        }
    }

}

//extension JournalViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var widthCell : CGSize = CGSize(width: 100, height: 100)
//        if collectionView == self.collectionViewWeekly {
//            widthCell = CGSize(width: 80, height: 60)
//        }
//
//        return widthCell
//    }
//}


// MARK : - UICollectionViewDelegate
extension JournalViewController : UICollectionViewDelegate, UIScrollViewDelegate{
    
    //    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    //      startingScrollingOffset = scrollView.contentOffset
    //    }
    //
    //    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //        let layout = self.collectionViewPhotoGallery.collectionViewLayout as! UICollectionViewFlowLayout
    //        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
    //        print(cellWidthIncludingSpacing)
    //
    //        var offset = targetContentOffset.pointee
    //        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
    //        let roundedIndex = round(index)
    //        print(roundedIndex)
    //
    //        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
    //
    //        targetContentOffset.pointee = offset
    ////            let pageWidht:CGFloat = 200.0 + 30.0
    ////            let currentOffset = scrollView.contentOffset.x
    ////            let targetOffset = CGFloat(targetContentOffset.pointee.x)
    ////            var newTargetOffset:CGFloat = 0.0
    ////
    ////            if targetOffset > currentOffset {
    ////                newTargetOffset = CGFloat(ceilf(Float((currentOffset / pageWidht) * pageWidht)))
    ////            }
    ////            else {
    ////                newTargetOffset = CGFloat(floorf(Float((currentOffset / pageWidht) * pageWidht)))
    ////            }
    ////
    ////            if newTargetOffset < 0.0 {
    ////                newTargetOffset = 0.0
    ////            }
    ////            else if newTargetOffset > scrollView.contentSize.width {
    ////                newTargetOffset = scrollView.contentSize.width
    ////            }
    ////            targetContentOffset.pointee = CGPoint(x: newTargetOffset, y: 0.0)
    //
    //    }
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
}


