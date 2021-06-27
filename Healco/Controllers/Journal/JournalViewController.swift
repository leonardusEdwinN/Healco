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
    
    
    
    @IBOutlet weak var buttonChangeDate: UIButton!
    @IBOutlet weak var collectionViewPhotoGallery: UICollectionView!
    @IBOutlet weak var viewSlideShowGallery: UIView!
    @IBOutlet weak var viewSummary: UIView!
    @IBOutlet weak var viewPieChart: UIView!
    @IBOutlet weak var collectionViewWeekly: UICollectionView!
    @IBOutlet weak var labelCommon: UILabel!
    @IBOutlet weak var labelUnhealthy: UILabel!
    @IBOutlet weak var labelHealthy: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    //    var barChartView = BarChartView()
    //Pie Chart
    var pieChartView = PieChartView()
    
    //Photo Gallery
    var carouselData = [Photo]()
    let cellScale : CGFloat = 0.6
    var picTakenDetail: UIImage!
    
    // Weekly CollectionCell
    var date = ["11 Jun", "12 Jun","13 Jun", "14 Jun","15 Jun", "16 Jun", "17 Jun"]
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
        getDate()
        //deleteRequest()
        initFirstCollectionView()
        // foodData
//        buttonAddJournal.layer.cornerRadius = 13.5
//        buttonAddJournal.imageView?.tintColor = UIColor.white
        buttonChangeDate.layer.cornerRadius = 13.5
        buttonChangeDate.layer.masksToBounds = true
        
        //pieChart
        pieChartView.delegate = self
        
        
        // UIcollectionview
        //galleryPhoto
        collectionViewPhotoGallery.register(UINib.init(nibName: "GalleryPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "galleryPhotoCell")
        collectionViewPhotoGallery.delegate = self
        collectionViewPhotoGallery.dataSource = self
//        let screenSize = UIScreen.main.bounds.size
//        let cellWidth = floor(screenSize.width * cellScale)
//        let cellHeight = floor(screenSize.height * cellScale)
//        let insetX = (collectionViewPhotoGallery.frame.size.width - cellWidth) / 2.0
//        let insetY = (collectionViewPhotoGallery.frame.size.height - cellHeight) / 2.0
//
//        let layout = collectionViewPhotoGallery.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
//        collectionViewPhotoGallery.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        
        //weekly
        collectionViewWeekly.register(UINib.init(nibName: "WeeklyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "weeklyCollectionViewCell")
        collectionViewWeekly.delegate = self
        collectionViewWeekly.dataSource = self
        collectionViewWeekly.allowsMultipleSelection = false
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        print("tanggal : \(formattedDate)")
        fetchData = myFetchRequestByDate(date: formattedDate)
        var count_healthy: Int = 0
        var count_common: Int = 0
        var count_unhealthy: Int = 0
        for(i) in fetchData.indices{
            carouselData.append(Photo(image: UIImage(data: fetchData[i].value(forKeyPath: "foodPhoto") as! Data)!, title: "Record", description: "\(fetchData[i].value(forKeyPath: "foodDescription") as! String)"))
            print("Tanggal: \(fetchData[i].value(forKeyPath: "dateTaken") as! String)")
            var status = fetchData[i].value(forKeyPath: "foodStatus") as? String
            if(status == "Healthy"){
                //count_healthy = fetchData.count
                count_healthy += 1
            }else if status == "Common"{
                count_common += 1
            } else{
                count_unhealthy += 1
            }
        }
        labelHealthy.text = "\(count_healthy) Healthy"
        labelCommon.text = "\(count_common) Common"
        labelUnhealthy.text = "\(count_unhealthy) Unhealthy"
    }
    
    func initFirstCollectionView(){
        carouselData.append(Photo(image: UIImage(systemName: "plus")!, title: "Add Journal", description: "Click Here To Add Journal"))
        //carouselData.append(Photo(image: picTakenDetail!, title: "Record", description: ""))
    }
    
    
    
    func getDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        let result = dateFormatter.string(from: date)
        labelDate.text = result
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
            print("Picked the date \(dateFormatter.string(from: date))")
            labelDate.text = dateFormatter.string(from: date)
            datePicker.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
    }
    
    @IBAction func buttonAddJournalClicked(_ sender: Any) {
        performSegue(withIdentifier: "goToFoodRecog", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFoodRecog",
             let foodRecogVC = segue.destination as? FoodRecogVC {
            foodRecogVC.modalPresentationStyle = .fullScreen
          }
        
    }
    
    func foodStatusChange(){
        
    }
    
}

// MARK : - UICollectionViewDataSource
extension JournalViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewWeekly {
            return date.count
        }else if collectionView == self.collectionViewPhotoGallery{
            return carouselData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewWeekly {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weeklyCollectionViewCell", for: indexPath) as! WeeklyCollectionViewCell
            
            cell.setUI(dateText: date[indexPath.item])
            
            
            return cell
        }else if collectionView == self.collectionViewPhotoGallery{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryPhotoCell", for: indexPath) as! GalleryPhotoCollectionViewCell
            
            cell.setUI(dataPhoto: carouselData[indexPath.item])
            
            return cell
        }
        
        return UICollectionViewCell()
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewWeekly {
            let cell = collectionView.cellForItem(at: indexPath) as! WeeklyCollectionViewCell
            cell.changeUpdate()
        }else if collectionView == self.collectionViewPhotoGallery{
            let cell = collectionView.cellForItem(at: indexPath) as! GalleryPhotoCollectionViewCell
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            let formattedDate = format.string(from: date)
            print("tanggal : \(formattedDate)")
            fetchData = myFetchRequestByDate(date: formattedDate)
            if(indexPath.item == 0){
                //pindah ke halaman foodRecog
                performSegue(withIdentifier: "goToFoodRecog", sender: self)
            }else if indexPath.item < fetchData.count - 1{
                //masuk ke halaman detail
                let food = getFoodFromCoreDataByName(name: fetchData[indexPath.item].value(forKeyPath: "foodName") as! String)
                let storyboard = UIStoryboard(name: "FoodDetail", bundle: nil);
                let vc = storyboard.instantiateViewController(withIdentifier: "FoodDetailViewController") as! FoodDetailViewController
                vc.selectedFood = food
                vc.imageHasilPhoto = UIImage(data: fetchData[indexPath.item].value(forKeyPath: "foodPhoto") as! Data)
                vc.modalPresentationStyle = .pageSheet
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewWeekly {
            let cell = collectionView.cellForItem(at: indexPath) as! WeeklyCollectionViewCell
            cell.changeUpdate()
        }
    }
    
    //how to equaly space
}

//extension JournalViewController : WeeklyCollectionViewCellProtocol{
//    func reloadCell() {
//        DispatchQueue.main.async {
//            self.collectionViewWeekly.reloadData()
//        }
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

extension JournalViewController : ChartViewDelegate{
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pieChartView.frame = CGRect(x: 0, y: 0, width: viewPieChart.frame.size.width, height: viewPieChart.frame.size.height)
        
        viewPieChart.addSubview(pieChartView)
        
        var entries = [ChartDataEntry]()
        
        for x in 1..<3{
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.colorful()
        
        let data = PieChartData(dataSet: set)
        pieChartView.data = data
    }
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


