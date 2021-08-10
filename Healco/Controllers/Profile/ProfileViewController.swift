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
    
    @IBOutlet weak var viewProfileHeader: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var genderOptions: UISegmentedControl!
    @IBOutlet weak var datePickerTanggalLahir: UIDatePicker!
    @IBOutlet weak var tinggiBadanTextField: UITextField!
    @IBOutlet weak var beratBadanTextField: UITextField!
    @IBOutlet weak var viewRec: UIView!
    @IBOutlet weak var segmentedControlGender: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profile = data.fetchProfile()
        // buat nge-hide keyboard
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        tinggiBadanTextField.keyboardType = .numberPad
        beratBadanTextField.keyboardType = .decimalPad
        //radius heaeder
        viewProfileHeader.layer.cornerRadius = 30
        
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
        datePickerTanggalLahir.isUserInteractionEnabled = false  }
    
    @IBAction func editButtonTapped(_ sender: Any) {
            print("Save")
       
        if edit == true {
        edit = false
            //merubah text button
            editButton.setTitle("Edit", for: .normal)
            //mengaktifkan field dan sebagainya
            tinggiBadanTextField.isUserInteractionEnabled = false
            tinggiBadanTextField.backgroundColor = UIColor.lightGray
            beratBadanTextField.isUserInteractionEnabled = false
            beratBadanTextField.backgroundColor = UIColor.lightGray
            genderOptions.isUserInteractionEnabled = false
            datePickerTanggalLahir.isUserInteractionEnabled = false
        }else{
        edit = true
            editButton.setTitle("Save", for: .normal)
            //menonaktifkan field dan sebagainya
            tinggiBadanTextField.isUserInteractionEnabled = true
            tinggiBadanTextField.backgroundColor = UIColor.white
            beratBadanTextField.isUserInteractionEnabled = true
            beratBadanTextField.backgroundColor = UIColor.white
            genderOptions.isUserInteractionEnabled = true
            datePickerTanggalLahir.isUserInteractionEnabled = true
            
        }
        let converter = NumberFormatter()
        converter.numberStyle = .decimal
        converter.groupingSeparator = "."
        converter.decimalSeparator = ","
        converter.locale = Locale(identifier: "id-ID")
        let berat = converter.number(from: beratBadanTextField.text!) as? Double ?? 0.0
        data.changeProfile(profile: profile[0], nama_pengguna: "", gender: genderTerpilih, tanggalLahir: datePickerTanggalLahir.date, tinggiBadan: Int32(tinggiBadanTextField.text!)!, beratBadan: berat)
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
