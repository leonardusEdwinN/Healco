//
//  LoginViewController.swift
//  Healco
//
//  Created by Kelny Tan on 03/08/21.
//

import UIKit

class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let gender: [String] = ["", "Pria", "Wanita"]
    var genderTerpilih: String = ""
    
    // function buat CoreData
    let data = CoreData()
    
    @IBOutlet weak var namaTextField: UITextField!
    @IBOutlet weak var tglLahirTextField: UITextField!
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

        // addBottomBorder untuk memberikan border bawah pada objek TextField
        namaTextField.addBottomBorder()
        tglLahirTextField.addBottomBorder()
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
    }

    @IBAction func btnMasuk_Tapped(_ sender: UIButton) {
        do{
            //data.addProfile(nama_pengguna: namaTextField.text!, gender: genderTerpilih, tanggalLahir: <#T##Date#>, tinggiBadan: <#T##Int32#>, beratBadan: <#T##Double#>)
            let storyboard = UIStoryboard(name: "HomeTabBar", bundle: nil);
            let viewController = storyboard.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar;
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil) 
        }
        catch{
            
        }
       
    }
    
    @objc func buttonKelamin_Tapped(_ sender: UIButton){
        _ = sender.tag
        switch(sender.tag){
        case 1:
            genderTerpilih = (sender.titleLabel?.text)!
        case 2:
            genderTerpilih = (sender.titleLabel?.text)!
        default:
            break
        }
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
