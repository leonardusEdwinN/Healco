//
//  LoginViewController.swift
//  Healco
//
//  Created by Kelny Tan on 03/08/21.
//

import UIKit
//import CoreData
import UserNotifications

class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate{
    let gender: [String] = ["", "Pria", "Wanita"]
    var genderTerpilih: String = ""
    var tipeMakan: String = ""
    var tglLahir = Date()
    
    // function buat CoreData
    let data = CoreDataClass()
    
    // notification center
    let notificationCenter = UNUserNotificationCenter.current()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.delegate = self
        
        // notification
        notificationLoginScheduling()
        // buat nge-hide keyboard
        hideKeyboardWhenTappedAround()
        
        // addBottomBorder untuk memberikan border bawah pada objek TextField
        namaTextField.addBottomBorder()
        //tglLahirTextField.addBottomBorder()
        tinggiBadanTextField.addBottomBorder()
        beratBadanTextField.addBottomBorder()
        
        // memasukkan func untuk kelamin
        priaKelaminButton.addTarget(self, action: #selector(self.buttonKelamin_Tapped), for: .touchUpInside)
        wanitaKelaminButton.addTarget(self, action: #selector(self.buttonKelamin_Tapped), for:.touchUpInside)
        
        // hide semua textfield waktu
        sarapanTextField.isHidden = true
        makanSiangTextField.isHidden = true
        makanMalamTextField.isHidden = true
        //genderPickerView.dataSource = self
        //genderPickerView.delegate = self
        
        // menjadikan keyboard menjadi numeric
        tinggiBadanTextField.keyboardType = .numberPad
        beratBadanTextField.keyboardType = .decimalPad
    }
    
    @IBAction func btnMasuk_Tapped(_ sender: UIButton) {
        //let tglLahirTerpilih = tglLahirDatePicker.date
        //let formatTglLahir = DateFormatter()
        //formatTglLahir.dateFormat = "yyyy-MM-dd"
        let converter = NumberFormatter()
        converter.numberStyle = .decimal
        converter.groupingSeparator = "."
        converter.decimalSeparator = ","
        converter.locale = Locale(identifier: "id-ID")
        let berat = converter.number(from: beratBadanTextField.text!) as? Double ?? 0.0
        //data.addProfile(nama_pengguna: namaTextField.text ?? "", gender: genderTerpilih, tanggalLahir: tglLahir, tinggiBadan: Int32(tinggiBadanTextField.text!) ?? 0 , beratBadan: berat)
        print("Berhasil!")
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
            print("gender: \(genderTerpilih)")
        case 2:
            genderTerpilih = (sender.titleLabel?.text)!
            print("gender: \(genderTerpilih)")
        default:
            break
        }
    }
    
    
    @IBAction func sarapanSwitch_Turned(_ sender: UISwitch) {
        if(sender.isOn){
            sarapanTextField.isHidden = false
            tipeMakan = "Sarapan"
        }
        else{
            sarapanTextField.isHidden = true
        }
    }
    
    @IBAction func makanSiangSwitch_Turned(_ sender: UISwitch) {
        if sender.isOn{
            makanSiangTextField.isHidden = false
            tipeMakan = "Makan Siang"
        }
        else{
            makanSiangTextField.isHidden = true
        }
    }
    
    @IBAction func makanMalamSwitch_Turned(_ sender: UISwitch) {
        if sender.isOn{
            makanMalamTextField.isHidden = false
            tipeMakan = "Makan Malam"
        }
        else{
            makanMalamTextField.isHidden = true
        }
    }
    
    @IBAction func datePicker_Changed(_ sender: Any) {
        tglLahir = tglLahirDatePicker.date
    }
}

extension LoginViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTerpilih = gender[row]
    }
    
    
    
    func notificationLoginScheduling(){
        let profil = data.fetchProfile()
        let content = UNMutableNotificationContent()
        if profil == nil {
            content.title = "Login"
            content.body = "Kamu masih belum login!"
            content.sound = UNNotificationSound.default
        }
        else{
            content.title = "Selamat datang!"
            content.body = "Selamat datang kembali! Kamu dapat melihat jurnal harian makanan kamu!"
            content.sound = UNNotificationSound.default
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let notifRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(notifRequest)
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
