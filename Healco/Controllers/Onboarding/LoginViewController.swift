//
//  LoginViewController.swift
//  Healco
//
//  Created by Kelny Tan on 03/08/21.
//

import UIKit
import CoreData
import UserNotifications

class LoginViewController: UIViewController{
    var genderTerpilih: String = ""
    var tglLahir = Date()
    var isSarapanOn: Bool = false
    var isSiangOn: Bool = false
    var isMalamOn: Bool = false
    
    // function buat CoreData
    let data = CoreDataClass()
    let center = UNUserNotificationCenter.current()
    
    @IBOutlet weak var namaTextField: UITextField!
    //@IBOutlet weak var tglLahirTextField: UITextField!
    @IBOutlet weak var tglLahirDatePicker: UIDatePicker!
    @IBOutlet weak var tinggiBadanTextField: UITextField!
    @IBOutlet weak var beratBadanTextField: UITextField!
    @IBOutlet weak var sarapanTextField: UITextField!
    @IBOutlet weak var makanSiangTextField: UITextField!
    @IBOutlet weak var makanMalamTextField: UITextField!
    @IBOutlet weak var sarapanSwitch: UISwitch!
    @IBOutlet weak var makanSiangSwitch: UISwitch!
    @IBOutlet weak var makanMalamSwitch: UISwitch!
    @IBOutlet weak var priaKelaminButton: UIButton!
    @IBOutlet weak var wanitaKelaminButton: UIButton!
    
    @IBOutlet weak var sarapanTimePicker: UIDatePicker!
    @IBOutlet weak var buttonMulai: UIButton!
    @IBOutlet weak var makanSiangTimePicker: UIDatePicker!
    @IBOutlet weak var makanMalamTimePicker: UIDatePicker!
    
    var timePicker = UIDatePicker()
    var toolbar = UIToolbar()
    override func viewDidLoad() {
        super.viewDidLoad()
        center.delegate = self
        
        // buat nge-hide keyboard
        hideKeyboardWhenTappedAround()
        
        //localLoginNotification()
        
        // memasukkan func untuk kelamin
        priaKelaminButton.addTarget(self, action: #selector(self.buttonKelamin_Tapped), for: .touchUpInside)
        wanitaKelaminButton.addTarget(self, action: #selector(self.buttonKelamin_Tapped), for:.touchUpInside)
        priaKelaminButton.layer.cornerRadius = 15
        wanitaKelaminButton.layer.cornerRadius = 15
        
        // hide semua textfield waktu
//        sarapanTextField.isHidden = true
//        makanSiangTextField.isHidden = true
//        makanMalamTextField.isHidden = true
        sarapanTimePicker.datePickerMode = .time
        sarapanTimePicker.isHidden = true
        makanSiangTimePicker.datePickerMode = .time
        makanSiangTimePicker.isHidden = true
        makanMalamTimePicker.datePickerMode = .time
        makanMalamTimePicker.isHidden = true
        
        
        //genderPickerView.dataSource = self
        //genderPickerView.delegate = self
        
        // menjadikan keyboard menjadi numeric
        tinggiBadanTextField.keyboardType = .numberPad
        beratBadanTextField.keyboardType = .decimalPad
        
        buttonMulai.layer.cornerRadius = 15
    }
    


    // Called when the date picker changes.

    @objc func updateDateField(sender: UIDatePicker) {
        sarapanTextField?.text = formatDateForDisplay(date: sender.date)
    }


    // Formats the date chosen with the date picker.

    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func btnMasuk_Tapped(_ sender: UIButton) {
        let tglLahirTerpilih = tglLahirDatePicker.date
        let formatTglLahir = DateFormatter()
        formatTglLahir.dateFormat = "dd MM yyyy"
        let strTglLahir = formatTglLahir.string(from: tglLahirTerpilih)
        print(strTglLahir)
        let converter = NumberFormatter()
        converter.numberStyle = .decimal
        converter.groupingSeparator = "."
        converter.decimalSeparator = ","
        converter.locale = Locale(identifier: "id-ID")
        let formatJam = DateFormatter()
        formatJam.dateFormat = "HH:mm"
        let berat = converter.number(from: beratBadanTextField.text!) as? Double ?? 0.0
        data.addProfile(nama_pengguna: "", gender: genderTerpilih, tanggalLahir: formatTglLahir.date(from: strTglLahir)! , tinggiBadan: Int32(tinggiBadanTextField.text!) ?? 0 , beratBadan: berat)
        print("Berhasil!")
        data.addNotif(sarapanOn: isSarapanOn, sarapanTime: formatJam.string(from: sarapanTimePicker.date), siangOn: isSiangOn, siangTime: formatJam.string(from: makanSiangTimePicker.date), malamOn: isMalamOn, malamTime: formatJam.string(from: makanMalamTimePicker.date))
        print("Jam sarapan: \(formatJam.string(from: sarapanTimePicker.date))")
        print("Jam makan siang: \(formatJam.string(from: makanSiangTimePicker.date))")
        print("Jam makan malam: \(formatJam.string(from: makanMalamTimePicker.date))")
        print("Berhasil")
        let storyboard = UIStoryboard(name: "HomeTabBar", bundle: nil);
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar;
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc func buttonKelamin_Tapped(_ sender: UIButton){
        _ = sender.tag
        switch(sender.tag){
        case 1:
            genderTerpilih = (sender.titleLabel?.text)!
            priaKelaminButton.backgroundColor = UIColor(named: "AvocadoGreen")
            priaKelaminButton.setTitleColor(.white, for: .normal)
            wanitaKelaminButton.backgroundColor = UIColor(named: "MangoYoghurt")
            wanitaKelaminButton.setTitleColor(UIColor(named: "StateUnactiveText"), for: .normal)
            print("gender: \(genderTerpilih)")
        case 2:
            genderTerpilih = (sender.titleLabel?.text)!
            wanitaKelaminButton.backgroundColor = UIColor(named: "AvocadoGreen")
            wanitaKelaminButton.setTitleColor(.white, for: .normal)
            priaKelaminButton.backgroundColor = UIColor(named: "MangoYoghurt")
            priaKelaminButton.setTitleColor(UIColor(named: "StateUnactiveText"), for: .normal)
            print("gender: \(genderTerpilih)")
        default:
            break
        }
    }
    
    
    @IBAction func sarapanSwitch_Turned(_ sender: UISwitch) {
        if(sender.isOn){
//            sarapanTextField.isHidden = false
            sarapanTimePicker.isHidden = false
            isSarapanOn = true
            
        }
        else{
//            sarapanTextField.isHidden = true
            sarapanTimePicker.isHidden = true
            isSarapanOn = false
        }
    }
    
    @IBAction func makanSiangSwitch_Turned(_ sender: UISwitch) {
        if sender.isOn{
//            makanSiangTextField.isHidden = false
            makanSiangTimePicker.isHidden = false
            isSiangOn = true
        }
        else{
//            makanSiangTextField.isHidden = true
            makanSiangTimePicker.isHidden = true
            isSiangOn = false
        }
    }
    
    @IBAction func makanMalamSwitch_Turned(_ sender: UISwitch) {
        if sender.isOn{
//            makanMalamTextField.isHidden = false
            makanMalamTimePicker.isHidden = false
            isMalamOn = true
        }
        else{
//            makanMalamTextField.isHidden = true
            makanMalamTimePicker.isHidden = true
            isMalamOn = false
        }
    }
    
    @IBAction func datePicker_Changed(_ sender: Any) {
        tglLahir = tglLahirDatePicker.date
    }
    
    func localLoginNotification(){
        let prof = data.fetchProfile()
        let content = UNMutableNotificationContent()
        if(prof != nil){
            content.title = "Sudah Login"
            content.body = "Berhasil!"
        }
        else{
            content.title = "Belum Login"
            content.body = "Lakukan sekarang!"
        }
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let register = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(register)
    }
}

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.green.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
