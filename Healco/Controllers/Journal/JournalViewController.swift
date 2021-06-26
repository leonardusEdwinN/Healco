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
    
    
    
    @IBOutlet weak var imageAddJournal: UIImageView!
    @IBOutlet weak var viewEmptyJournal: UIView!
    @IBOutlet weak var labelPieChartDetail: UILabel!
    @IBOutlet weak var labelPieChartPercentage: UILabel!
    @IBOutlet weak var stackPieChart: UIStackView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDate()
        if(carouselData.isEmpty){
            viewEmptyJournal.isHidden = false
        }else{
            viewEmptyJournal.isHidden = true
        }
        
        // add tap gesture to image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.goToFoodRecog))

        imageAddJournal.isUserInteractionEnabled = true
        imageAddJournal.addGestureRecognizer(tapGestureRecognizer)
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
        
        //Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = 1980
        dateComponents.month = 7
        dateComponents.day = 11
        dateComponents.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
        dateComponents.hour = 8
        dateComponents.minute = 34
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents)
        print("Hari ini: \(Date())")
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
    @objc func goToFoodRecog() {
        performSegue(withIdentifier: "goToFoodRecog", sender: self)
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
            
//            let numberOfCell = 7
//           let cellSpecing = 20
//               if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                layout.itemSize = CGSize(width: (Int(UIScreen.main.bounds.width) - (cellSpecing * (numberOfCell + 1))) / numberOfCell, height: 50)
//                    layout.invalidateLayout()
//                }
            
            cell.setUI(dateText: date[indexPath.item])
            
            
            return cell
        }else if collectionView == self.collectionViewPhotoGallery{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryPhotoCell", for: indexPath) as! GalleryPhotoCollectionViewCell
            
            if(indexPath.item == 0){
                
                cell.photoGalleryView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            }
            
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
            
            if(indexPath.item == 0){
                //pindah ke halaman foodRecog
                performSegue(withIdentifier: "goToFoodRecog", sender: self)
            }else{
                //masuk ke halaman detail
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
        
//        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Quicksand-Bold", size: 20.0)! ]
//        let myAttrString = NSAttributedString(string: "66 % \n Health", attributes: myAttribute)
//
//        pieChartView.centerAttributedText = myAttrString
        
        pieChartView.holeRadiusPercent = 0.7
        pieChartView.transparentCircleRadiusPercent = 0.0
        pieChartView.drawHoleEnabled = true
        
        
        // hides center text
        pieChartView.drawCenterTextEnabled = true
        pieChartView.legend.enabled = false
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.entryLabelColor = .clear
        pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        pieChartView.setExtraOffsets(left: -15, top: -15, right: -15, bottom: -15)
        
        
        
        
        viewPieChart.addSubview(pieChartView)
        pieChartView.addSubview(stackPieChart)
        
        
        
        var entries = [ChartDataEntry]()
        
        for x in 1..<3{
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = PieChartDataSet(entries: entries)
        set.colors = [UIColor(red: 0.09, green: 0.54, blue: 0.38, alpha: 1.00), UIColor.red]
        
        let data = PieChartData(dataSet: set)
        data.setDrawValues(false)
        pieChartView.data = data
    }
}


