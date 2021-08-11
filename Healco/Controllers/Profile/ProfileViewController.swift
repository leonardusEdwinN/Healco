//
//  ProfileViewController.swift
//  Healco
//
//  Created by Rian Sanjaya on 09/08/21.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController{
    let gender: [String] = ["", "Pria", "Wanita"]
    var genderTerpilih: String = ""
    var tipeMakan: String = ""
    var tglLahir = Date()
    var edit : Bool!
    
    // function buat CoreData
    let data = CoreDataClass()
    var profile : [ProfileEntity] = [ProfileEntity]()
    var notification : [NotificationEntity] = [NotificationEntity]()
    
    var isSarapanOn: Bool = false
    var isSiangOn: Bool = false
    var isMalamOn: Bool = false
    let tanggalHariIni = Date()
    let formatter = DateFormatter()
    
    
    @IBOutlet weak var viewProfileHeader: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var genderOptions: UISegmentedControl!
    @IBOutlet weak var datePickerTanggalLahir: UIDatePicker!
    @IBOutlet weak var tinggiBadanTextField: UITextField!
    @IBOutlet weak var beratBadanTextField: UITextField!
    @IBOutlet weak var viewRec: UIView!
    @IBOutlet weak var segmentedControlGender: UISegmentedControl!
    
    //notifikasi
    @IBOutlet weak var viewNotifikasi: UIView!
    @IBOutlet weak var labelSarapan: UILabel!
    @IBOutlet weak var switchSarapan: UISwitch!
    @IBOutlet weak var datePickerSarapan: UIDatePicker!
    
    @IBOutlet weak var labelMakanSiang: UILabel!
    @IBOutlet weak var switchMakanSiang: UISwitch!
    @IBOutlet weak var datePickerMakanSiang: UIDatePicker!
    
    @IBOutlet weak var labelMakanMalam: UILabel!
    @IBOutlet weak var switchMakanMalam: UISwitch!
    @IBOutlet weak var datePickerMakanMalam: UIDatePicker!
    
    @IBAction func switchSarapanPressed(_ sender: UISwitch) {
        if(sender.isOn){
            datePickerSarapan.isHidden = false
            isSarapanOn = true
        }
        else{
            datePickerSarapan.isHidden = true
            isSarapanOn = false
        }
    }
    
    @IBAction func switchMakanSiangPressed(_ sender: UISwitch) {
        if sender.isOn{
            datePickerMakanSiang.isHidden = false
            isSiangOn = true
        }
        else{
            datePickerMakanSiang.isHidden = true
            isSiangOn = false
        }
    }
    
    @IBAction func switchMakanMalamPressed(_ sender: UISwitch) {
        if sender.isOn{
            datePickerMakanMalam.isHidden = false
            isMalamOn = true
        }
        else{
            datePickerMakanMalam.isHidden = true
            isMalamOn = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profile = data.fetchProfile()
        notification = data.fetchNotification()
        
        
        
        // buat nge-hide keyboard
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        tinggiBadanTextField.keyboardType = .numberPad
        beratBadanTextField.keyboardType = .decimalPad
        //radius heaeder
        viewProfileHeader.layer.cornerRadius = 30
        viewNotifikasi.layer.cornerRadius = 15
        viewRec.layer.cornerRadius = 15
        
        
        self.editButton.tag = 0
        //manggil data dari core data
        tinggiBadanTextField.text = "\(profile[0].tinggi_badan)"
        beratBadanTextField.text = "\(profile[0].berat_badan)"
        datePickerTanggalLahir.date = profile[0].tanggal_lahir!
        
        if profile[0].gender == "Pria"{
            genderOptions.selectedSegmentIndex = 0
        }
        else if profile[0].gender == "Wanita" {
            genderOptions .selectedSegmentIndex = 1
        }
        
        
        //menonaktifkan field dan sebagainya
        tinggiBadanTextField.isUserInteractionEnabled = false
        tinggiBadanTextField.backgroundColor = UIColor.lightGray
        beratBadanTextField.isUserInteractionEnabled = false
        beratBadanTextField.backgroundColor = UIColor.lightGray
        genderOptions.isUserInteractionEnabled = false
        datePickerTanggalLahir.isUserInteractionEnabled = false
        
        switchSarapan.isUserInteractionEnabled = false
        switchSarapan.isOn = notification[0].sarapanOn
        datePickerSarapan.datePickerMode = .time
        datePickerSarapan.isHidden = switchSarapan.isOn ? false : true
        
        guard let jamSarapan = notification[0].sarapanTime else {return}
        print("JAM JAM SARAPAN \(jamSarapan.convertToDate())")
        
        
    
        
//        guard let jamSarapan = notification[0].sarapanTime else {return}
//        let jamFormat = formatter.date(from: jamSarapan)
//        formatter.dateFormat = "HH:mm" //Your date format
//        formatter.timeZone = TimeZone(abbreviation: "UTC+7") //Current time zone
//        //according to date format your date string
//
//        print("JAM JAM JAM : \(jamFormat)")
        
        switchMakanSiang.isUserInteractionEnabled = false
        switchMakanSiang.isOn = notification[0].siangOn
        datePickerMakanSiang.datePickerMode = .time
        datePickerMakanSiang.isHidden = switchMakanSiang.isOn ? false : true
        
        switchMakanMalam.isUserInteractionEnabled = false
        switchMakanMalam.isOn = notification[0].malamOn
        datePickerMakanMalam.datePickerMode = .time
        datePickerMakanMalam.isHidden = switchMakanMalam.isOn ? false : true
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
        if edit == true {
            //DATA SAVED
            //merubah text button
            editButton.setTitle("Edit", for: .normal)
            //mengaktifkan field dan sebagainya
            tinggiBadanTextField.isUserInteractionEnabled = false
            tinggiBadanTextField.backgroundColor = UIColor.lightGray
            beratBadanTextField.isUserInteractionEnabled = false
            beratBadanTextField.backgroundColor = UIColor.lightGray
            genderOptions.isUserInteractionEnabled = false
            datePickerTanggalLahir.isUserInteractionEnabled = false
            
            switchSarapan.isUserInteractionEnabled = false
            switchMakanSiang.isUserInteractionEnabled = false
            switchMakanMalam.isUserInteractionEnabled = false
            let converter = NumberFormatter()
            converter.numberStyle = .decimal
            converter.groupingSeparator = "."
            converter.decimalSeparator = ","
            converter.locale = Locale(identifier: "id-ID")
            let berat = converter.number(from: beratBadanTextField.text!) as? Double ?? 0.0
            //change data profile berdasarkan data yang di edit
            data.changeProfile(profile: profile[0], nama_pengguna: "", gender: genderTerpilih, tanggalLahir: datePickerTanggalLahir.date, tinggiBadan: Int32(tinggiBadanTextField.text!)!, beratBadan: berat)
            
            //change notifikasi
            
            edit = false
        }else{
            //DATA EDIT
            editButton.setTitle("Save", for: .normal)
            //menonaktifkan field dan sebagainya
            tinggiBadanTextField.isUserInteractionEnabled = true
            tinggiBadanTextField.backgroundColor = UIColor.white
            beratBadanTextField.isUserInteractionEnabled = true
            beratBadanTextField.backgroundColor = UIColor.white
            genderOptions.isUserInteractionEnabled = true
            datePickerTanggalLahir.isUserInteractionEnabled = true
            
            switchSarapan.isUserInteractionEnabled = true
            switchMakanSiang.isUserInteractionEnabled = true
            switchMakanMalam.isUserInteractionEnabled = true
            
            
           
            
            
            edit = true
            
        }
        
    }
    
    @IBAction func genderSwitch(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("masuk pria")
            genderTerpilih = "Pria"
        }
        else if sender.selectedSegmentIndex == 1 {
            print("masuk wanita")
            genderTerpilih = "Wanita"
        }
    }
    
    
}

//extension String {
//    func createDateObjectWithTime(format: String = "HH:mm") -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        guard let dateObjectWithTime = dateFormatter.date(from: self) else { return nil }
//
//        let gregorian = Calendar(identifier: .gregorian)
//        let now = Date()
//        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
//        var dateComponents = gregorian.dateComponents(components, from: now)
//
//        var calendar = Calendar.current
//        guard let timezone = TimeZone(identifier: "Asia/Jakarta") else { return nil }
//        calendar.timeZone = timezone
//        dateComponents.hour = calendar.component(.hour, from: dateObjectWithTime)
//        dateComponents.minute = calendar.component(.minute, from: dateObjectWithTime)
//        dateComponents.second = 0
//
//        return gregorian.date(from: dateComponents)
//    }
//}

extension String {
    func convertToDate() -> Date? {
        let arr = self.split(separator: ":")
        guard
            let hour = Int(arr.first ?? ""),
            let minute = Int(arr.last ?? "")
        else { return nil }
        
        print("\(hour) : \(minute)")
        
        let component = DateComponents(hour: hour, minute: minute)
        print("\(component)")
        var cal = Calendar.current
        guard let timezone = TimeZone(identifier: "Asia/Jakarta") else { return nil }
        cal.timeZone = timezone
        let date = cal.date(from: component)
        print(date)
        return date
    }
}
