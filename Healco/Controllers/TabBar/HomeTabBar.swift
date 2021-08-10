//
//  HomeTabBar.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 29/07/21.
//

import Foundation
import UIKit
import UserNotifications

class HomeTabBar : UITabBarController,UITabBarControllerDelegate{
    
    //create imagepicker viewcontroller
    private var imagePickerControler =  UIImagePickerController()
    
    // notification center
    let notificationCenter = UNUserNotificationCenter.current()
    
    // CoreData konektor
    let data = CoreDataClass()
    
    required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            self.delegate = self
            notificationCenter.delegate = self
            self.setupMiddleButton()
            self.notificationAlertScheduling()
       }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//            self.tabBar.barTintColor = UIColor.red
//            self.tabBar.unselectedItemTintColor = UIColor.darkGray
//            self.tabBar.tintColor = UIColor.white
//      }
    
    // TabBarButton – Setup Middle Button
        func setupMiddleButton() {

            let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
            
//            STYLE THE BUTTON YOUR OWN WAY
            middleBtn.setImage(UIImage(named: "addIcon"), for: .normal)
//            middleBtn.setImage(UIImage(named: "plus.circle"), for: .normal)
            middleBtn.tintColor = .white
//            middleBtn.layer.insertSublayer(gradient, at: 0)
            middleBtn.layer.backgroundColor = UIColor(named: "AvocadoGreen")?.cgColor
            middleBtn.layer.cornerRadius = middleBtn.bounds.size.width / 2
            
            //add to the tabbar and add click event
            self.tabBar.addSubview(middleBtn)
            middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)

            self.view.layoutIfNeeded()
        }

        // Menu Button Touch Action
        @objc func menuButtonAction(sender: UIButton) {
//            self.selectedIndex = 2   //to select the middle tab. use "1" if you have only 3 tabs.
            print("YUHU")
            PresentActionSheet()

//            performSegue(withIdentifier: "goToFoodRecog", sender: self.tabBarController)
            
        }
    
    //presentation Action sheet
    private func PresentActionSheet(){
        
        
        let actionSheet = UIAlertController(title: "Select Photo", message: "Choose", preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor(named: "DarkGreen")
        
        //button 1
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default){ (action: UIAlertAction) in
            
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePickerControler.sourceType = .photoLibrary
                self.imagePickerControler.delegate = self
                self.imagePickerControler.allowsEditing = true
                self.present(self.imagePickerControler, animated: true, completion: nil)
            }else{
                fatalError("Photo library not avaliable")
            }
        }
        
        //button 2
        let CameraAction = UIAlertAction(title: "Camera", style: .default){ (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePickerControler.sourceType = .camera
                self.imagePickerControler.delegate = self
                self.imagePickerControler.allowsEditing = true
                self.present(self.imagePickerControler, animated: true, completion: nil)
            }
            else{
                fatalError("Camera not Avaliable")
            }
            
        }
        
        //button 3
        let cancel = UIAlertAction(title: "Cancel", style:.cancel, handler: nil)
        
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(CameraAction)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFoodRecog",
           let foodRecogVC = segue.destination as? FoodRecogVC {
            foodRecogVC.modalPresentationStyle = .fullScreen
        }
    }
}

extension HomeTabBar : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            //picker.dismiss(animated: true, completion: nil)
            
            //go to another viewcontroller
            let storyboard : UIStoryboard = UIStoryboard(name: "FoodDetail", bundle: nil)
            let VC  = storyboard.instantiateViewController(withIdentifier: "FoodNameViewController") as! FoodNameViewController
            
            
//            let fileManager = NSFileManager.defaultManager()
//            let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//            let documentDirectory = urls[0] as NSURL
            
            
            //parsing image to  another view
            VC.imageHasilFoto = uiImage
            VC.modalPresentationStyle = .fullScreen
            picker.present(VC, animated: true, completion: nil)
            

        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true , completion: nil)
    }
    
    func notificationAlertScheduling(){
        //notificationCenter.removeAllPendingNotificationRequests()
        let notif = data.fetchNotification()
        var strJamSarapan: String? = ""
        var strJamSiang: String? = ""
        var strJamMalam: String? = ""
        var sarapanOn: Bool = false
        var siangOn: Bool = false
        var malamOn: Bool = false
        if(notif != nil){
            let sarapanNotif = notif?.value(forKeyPath: "sarapanOn") as? Bool
            let siangNotif = notif?.value(forKeyPath: "siangOn") as? Bool
            let malamNotif = notif?.value(forKeyPath: "malamOn") as? Bool
            
            if sarapanNotif!{
                strJamSarapan = notif?.value(forKeyPath: "sarapanTime") as? String ?? ""
                sarapanOn = sarapanNotif!
                print("Sarapan: \(strJamSarapan ?? "")")
            }
            if siangNotif!{
                strJamSiang = notif?.value(forKeyPath: "siangTime") as? String ?? ""
                siangOn = siangNotif!
                print("Siang: \(strJamSiang ?? "")")
            }
            if malamNotif!{
                strJamMalam = notif?.value(forKeyPath: "malamTime") as? String ?? ""
                malamOn = malamNotif!
                print("Malam: \(strJamMalam ?? "")")
            }
        }
        let tglFormatter = DateFormatter()
        tglFormatter.dateFormat = "HH:mm"
        
        
        if sarapanOn{
            let jamSarapan: Date? = tglFormatter.date(from: strJamSarapan ?? "") ?? nil
            print("Status sarapan: " + String(sarapanOn))
            print("Jam sarapan: " + tglFormatter.string(from: jamSarapan ?? Date()))
            waktuNotificationMuncul(waktu: jamSarapan!, title: "Jam Sarapan", body: "Sekarang jam makan sarapan, jangan lupa catatin makananmu ya!")
        }
        if siangOn{
            let jamSiang: Date? = tglFormatter.date(from: strJamSiang ?? "") ?? nil
            print("Status siang: " + String(siangOn))
            print("Jam makan siang: " + tglFormatter.string(from: jamSiang ?? Date()))
            waktuNotificationMuncul(waktu: jamSiang!, title: "Jam Makan Siang", body: "Sekarang jam makan siang, ingat catatin ya!")
        }
        if malamOn{
            let jamMalam: Date? = tglFormatter.date(from: strJamMalam ?? "") ?? nil
            print("Status malam: " + String(malamOn))
            print("Jam makan malam: " + tglFormatter.string(from: jamMalam ?? Date()))
            waktuNotificationMuncul(waktu: jamMalam!, title: "Jam Makan Malam", body: "Jam makan malam, jangan lupa catatin sebelum makan sampai bobo ya!")
        }
    }
    
    private func waktuNotificationMuncul(waktu: Date, title: String, body: String){
        var component = DateComponents()
        component.calendar = Calendar.current
        component.hour = component.calendar?.component(.hour, from: waktu)
        component.minute = component.calendar?.component(.minute, from: waktu)
        let contentNotif = UNMutableNotificationContent()
        contentNotif.title = title
        contentNotif.body = body
        contentNotif.sound = UNNotificationSound.default
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: contentNotif, trigger: trigger)
        notificationCenter.add(request)
    }
}



