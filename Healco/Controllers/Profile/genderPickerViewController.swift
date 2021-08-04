//
//  GenderPickerViewController.swift
//  Profile
//
//  Created by Rinaldi LNU on 03/08/21.
//

import UIKit
import CoreData

class GenderPickerViewController: UIViewController {
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var genderPicker: UIPickerView!
    
    var pickerSelected = "Male"
    var pickerData: [String] = ["Male", "Female", "Other"]
    var profileData = [ProfileEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = appDelegate?.persistentContainer.viewContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.genderPicker.delegate = self
        self.genderPicker.dataSource = self
        self.btnSelect.layer.cornerRadius = 15
        self.genderPicker.backgroundColor = .systemBackground
        self.genderPicker.layer.cornerRadius = 15
        view.backgroundColor =  UIColor(white: 0, alpha: 0.3)
        
        switch pickerSelected {
            case "Male":
                self.genderPicker.selectRow(0, inComponent: 0, animated: true)
            case "Female":
                self.genderPicker.selectRow(1, inComponent: 0, animated: true)
            case "Other":
                self.genderPicker.selectRow(2, inComponent: 0, animated: true)
            default:
                self.genderPicker.selectRow(2, inComponent: 0, animated: true)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionSelectGender(_ sender: Any) {
        
        let profileRequest: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        do {
            try profileData = managedObjectContext.fetch(profileRequest)
        } catch {
            print("Couldn't load the profile data!")
        }
        let userProfile = profileData.first!
        switch self.genderPicker.selectedRow(inComponent: 0) {
            case 0:
                userProfile.setValue("Male", forKey: "gender")
            case 1:
                userProfile.setValue("Female", forKey: "gender")
            case 2:
                userProfile.setValue("Other", forKey: "gender")
            default:
                userProfile.setValue("Other", forKey: "gender")
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to edit!")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGender"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GenderPickerViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
}
