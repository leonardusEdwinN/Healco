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
    
    
    @IBOutlet weak var namaTextField: UITextField!
    @IBOutlet weak var umurTextField: UITextField!
    @IBOutlet weak var tinggiBadanTextField: UITextField!
    @IBOutlet weak var beratBadanTextField: UITextField!
    @IBOutlet weak var waktuSarapanTextField: UITextField!
    @IBOutlet weak var waktuSiangTextField: UITextField!
    @IBOutlet weak var waktuMalamTextField: UITextField!
    @IBOutlet weak var genderPickerView: UIPickerView!
    
    // function buat CoreData
    let data = CoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        genderPickerView.dataSource = self
        genderPickerView.delegate = self
    }

    @IBAction func btnMasuk_Tapped(_ sender: UIButton) {
        
        /* let storyboard = UIStoryboard(name: "HomeTabBar", bundle: nil);
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar;
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil) */
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
