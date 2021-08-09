//
//  HomeTabBar.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 29/07/21.
//

import Foundation
import UIKit


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
    
    // TabBarButton – Setup Middle Button
        func setupMiddleButton() {

            let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
            //let gradient = CAGradientLayer()

//            gradient.frame = middleBtn.bounds
//            gradient.colors = [UIColor.gray.cgColor, UIColor.green.cgColor]
            
//            STYLE THE BUTTON YOUR OWN WAY
            middleBtn.setImage(UIImage(named: "addIcon"), for: .normal)
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
        let notif = data.fetchNotification()
        let content = UNMutableNotificationContent()
        let timeSystem = Date()
        let calendarSekarang = Calendar.current
        let jamSekarang = calendarSekarang.component(.hour, from: timeSystem)
        let menitSekarang = calendarSekarang.component(.minute, from: timeSystem)
        var waktuComponent = DateComponents()
        waktuComponent.calendar = calendarSekarang
        waktuComponent.hour = jamSekarang
        waktuComponent.minute = menitSekarang
        let strJamSekarang: String = "\(waktuComponent.hour ?? 0)" + ":" + "\(waktuComponent.minute ?? 0)"
        print("Jam: \(waktuComponent.hour ?? 0)" + " Menit: \(waktuComponent.minute ?? 0)")
        let jamSarapan: String = notif?.value(forKeyPath: "sarapanTime") as? String ?? ""
        let jamSiang: String = notif?.value(forKeyPath: "siangTime") as? String ?? ""
        let jamMalam: String = notif?.value(forKeyPath: "malamTime") as? String ?? ""
        print("Sarapan: " + jamSarapan)
        print("Siang: " + jamSiang)
        print("Malam: " + jamMalam)
        if(strJamSekarang == notif?.value(forKeyPath: "sarapanTime") as? String){
            content.title = "Jam Sarapan"
            content.body = "Hai! Sekarang waktunya sarapan! "
        }
        else if (strJamSekarang == notif?.value(forKeyPath: "siangTime") as? String){
            content.title = "Jam Makan Siang"
            content.body = "Hai! Sekarang waktunya untuk makan siang! "
        }
        else if (strJamSekarang == notif?.value(forKeyPath: "malamTime") as? String){
            content.title = "Jam Makan Malam"
            content.body = "Hai! Sekarang waktunya untuk makan malam! "
        }
        content.body += "Ingat ya untuk mencatat makananmu ya!"
        content.sound = UNNotificationSound.default
        let trigger = UNCalendarNotificationTrigger(dateMatching: waktuComponent, repeats: true)
        let notifRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(notifRequest)
    }
}



