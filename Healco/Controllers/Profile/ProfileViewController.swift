//
//  ProfileViewController.swift
//  Profile
//
//  Created by Rian on 03/08/21.
//

import UIKit
import CoreData

struct MapingDataProfile {
    var index: Int
    var name: String
    var value: String
    var key: String
    var isEdited: Bool
}

class ProfileViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    let profileTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = UIColor.clear
        return tableView
    }()
    
    var isVCEdit: Bool = false
    
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var selectedGender: String?
    public var formatData: [MapingDataProfile] = []
    var profileData = [ProfileEntity]()
    
    
    func getDataProfile() {
        print("TEST MEAL")
        let data = CoreDataClass()
        let profile  = data.fetchProfile()
//
        if profile == nil {
            formatData.append(MapingDataProfile(index: 0, name: "Jenis Kelamin", value: "", key: "gender", isEdited: false))
            formatData.append(MapingDataProfile(index: 1, name: "Umur", value: "", key: "umur", isEdited: false))
            formatData.append(MapingDataProfile(index: 2, name: "Tinggi Badan", value: "", key: "tinggi_badan", isEdited: false))
            formatData.append(MapingDataProfile(index: 3, name: "Berat Badan", value: "", key: "berat_badan", isEdited: false))

        } else {
//            formatData.append(MapingDataProfile(index: 0, name: "Jenis Kelamin", value: profileData[0].gender ?? "", key: "gender", isEdited: false))
//            formatData.append(MapingDataProfile(index: 1, name: "Umur", value: String(profileData[0].umur), key: "umur", isEdited: false))
//            formatData.append(MapingDataProfile(index: 2, name: "Tinggi Badan", value: String(profileData[0].tinggi_badan), key: "tinggi_badan", isEdited: false))
//            formatData.append(MapingDataProfile(index: 3, name: "Berat Badan", value: String(profileData[0].berat_badan), key: "berat_badan", isEdited: false))
        }
        profileTableView.reloadData()
    }
    
    func saveDataProfile() {
        let profileRequest: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        do {
            try profileData = managedObjectContext.fetch(profileRequest)
        } catch {
            print("Couldn't load the profile data!")
        }
        
        if profileData.count == 0 {
            //CREATE
            print("START TO GET ENTITY")
            let entity = NSEntityDescription.entity(forEntityName: "ProfileEntity", in: managedObjectContext)
            let newInventory = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            
            for i in 0..<formatData.count {
                if formatData[i].key == "gender" {
                    newInventory.setValue(formatData[i].value, forKey: formatData[i].key)
                } else {
                    newInventory.setValue(Int64(formatData[i].value), forKey: formatData[i].key)
                }
            }
            
            do {
                try managedObjectContext.save()
            } catch {
                print("Failed to create!")
            }
            
        } else {
            //EDIT
            let userProfile = profileData.first!
            for i in 0..<formatData.count {
                if formatData[i].key == "gender" {
                    userProfile.setValue(formatData[i].value, forKey: formatData[i].key)
                } else {
                    userProfile.setValue(Int64(formatData[i].value), forKey: formatData[i].key)
                }
            }
            
            do {
                try managedObjectContext.save()
            } catch {
                print("Failed to edit!")
            }
            
        }
//        profileTableView.reloadData()
    }
    
    func setupTableView() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(SettingsProfileTableViewCell.self, forCellReuseIdentifier: SettingsProfileTableViewCell.identifier)
        view.addSubview(profileTableView)
        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            profileTableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = appDelegate?.persistentContainer.viewContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        setupTableView()
        getDataProfile()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.performPicker), name: NSNotification.Name(rawValue: "showPickerController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateGender), name: NSNotification.Name(rawValue: "updateGender"), object: nil)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func updateGender() {
        formatData.removeAll()
        getDataProfile()
    }
    
    @objc func performPicker() {
//        self.performSegue(withIdentifier: "segueGender", sender: nil)
        
        self.performSegue(withIdentifier: "segueGender", sender: nil)
    }
    
    
    @objc func buttonTapped(sender: UIButton) {
        var btnTitle: String = ""
        if self.isVCEdit == true {
            for i in 0..<formatData.count {
                let cell = profileTableView.cellForRow(at: [0, i]) as! SettingsProfileTableViewCell
                formatData[i].value = cell.textField.text!
                formatData[i].isEdited = false
            }
            saveDataProfile()
            btnTitle = "Edit"
            self.isVCEdit = false
            
        } else {
            for i in 0..<formatData.count {
                if i != 0 {
                    formatData[i].isEdited = true
                }
            }
            btnTitle = "Save"
            self.isVCEdit = true
            
        }
        sender.setTitle(btnTitle, for: .normal)
        profileTableView.reloadData()
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame: CGRect = profileTableView.frame
        let Buttons: UIButton = UIButton(frame: CGRect(x: frame.size.width - 40 - 50, y: -15, width: 50, height: 30))
        Buttons.setTitle(isVCEdit == false ? "Edit" : "Save", for: .normal)
        Buttons.setTitleColor(.systemBlue, for: .normal)
        Buttons.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: -10, width: frame.size.width, height: 50))
        headerView.addSubview(Buttons)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profile = formatData[indexPath.row]
        guard let cell = profileTableView.dequeueReusableCell(withIdentifier: SettingsProfileTableViewCell.identifier, for: indexPath) as? SettingsProfileTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: profile)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && isVCEdit {
            self.performSegue(withIdentifier: "segueGender", sender: nil)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let nav = segue.destination as? GenderPickerViewController {
//            nav.pickerSelected = formatData[0].value
//            nav.modalPresentationStyle = .overCurrentContext
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueGender",
           let foodRecogVC = segue.destination as? GenderPickerViewController {
            foodRecogVC.modalPresentationStyle = .overCurrentContext
        }
    }
    
}
