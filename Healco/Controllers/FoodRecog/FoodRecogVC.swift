//
//  FoodRecogVC.swift
//  Healco
//
//  Created by Ericson Hermanto on 10/06/21.
//


import UIKit
import AVKit
import Vision


struct profile {
    //in year
    var age : Float
    //male or female
    var gender : Gender
    // in cm
    var height : Float
    //in kg
    var weight : Float
}

enum Gender {
    case male
    case female
}

class FoodRecogVC: UIViewController {
    
//    //capture Session
//    var captureSession: AVCaptureSession?
//    //Photo Output
//    let output = AVCapturePhotoOutput()
//    //Video Preview
//    let previewLayer = AVCaptureVideoPreviewLayer()
    //var imageSend = UIImage()
    
    //create imagepicker viewcontroller
    private var imagePickerControler =  UIImagePickerController()
    
    
    //backButton
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ActionButton(_ sender: Any) {
        PresentActionSheet()
    }
    
    
//    private let shutterButton : UIButton = {
//        let button = UIButton(frame: CGRect(x:0, y:0, width: 80, height: 80))
//
//        button.layer.cornerRadius = 40
//        button.layer.borderWidth = 5
//
//        button.layer.borderColor = UIColor.white.cgColor
//        return button
//    }()
//
//    private let innerButton : UIButton = {
//        let button = UIButton(frame: CGRect(x:0, y:0, width: 60, height: 60))
//        button.layer.cornerRadius = 30
//        button.layer.backgroundColor = UIColor.white.cgColor
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //view.backgroundColor = .black
        //view.layer.addSublayer(previewLayer)
        //view.addSubview(shutterButton)
        //view.addSubview(innerButton)
        
        //self.navigationController?.isNavigationBarHidden = true
        //self.navigationController?.navigationBar.barTintColor = UIColor.black
        //checkCameraPermissions()
        //innerButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)

        
//        //camera config
//        captureSession.sessionPreset = .photo
//        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
//        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
//        captureSession.addInput(input)
//
//        captureSession.startRunning()
//
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        view.layer.addSublayer(previewLayer)
//        previewLayer.frame = view.frame
//
//        let dataOutput  = AVCaptureVideoDataOutput()
//        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        captureSession.addOutput(dataOutput)
//
//        VNImageRequestHandler(cgImage: <#T##CGImage#>, options: <#T##[VNImageOption : Any]#>)
    }
    
    //BMR calculation
    private func BMR(profile : profile) -> Float{
        var bmrScore : Float?
        
        if profile.gender == .male {
            bmrScore = 88.362 + (13.397 * profile.weight) + (4.799 * profile.height) - (5.677 * profile.age)
        }else{
            bmrScore = 447.593 + (9.247 * profile.weight) + (3.098 * profile.height) - (4.330 * profile.age)
        }
        return bmrScore ?? 0.0
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

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        previewLayer.frame = view.alignmentRect(forFrame: .init(x: 0, y: view.frame.size.height/6, width: view.frame.size.width, height: view.frame.size.height - 300))
//        //previewLayer.frame = view.bounds
//        shutterButton.center = CGPoint(x: view.frame.size.width/2,
//                                       y: view.frame.size.height - 100)
//
//        innerButton.center = CGPoint(x: view.frame.size.width/2,
//                                       y: view.frame.size.height - 100)
//    }
    
//    private func checkCameraPermissions(){
//        switch AVCaptureDevice.authorizationStatus(for: .video){
//
//        case .notDetermined:
//            //request
//            AVCaptureDevice.requestAccess(for: .video) { [weak self]granted in
//                guard granted else {
//                    return
//                }
//                DispatchQueue.main.async {
//                    self?.setupCamera()
//                }
//            }
//        case .restricted:
//            break
//        case .denied:
//            break
//        case .authorized:
//            setupCamera()
//        @unknown default:
//
//            break
//        }
//    }
    
//    private func setupCamera(){
//        let session = AVCaptureSession()
//        if let device = AVCaptureDevice.default(for: .video){
//            do {
//                let input = try AVCaptureDeviceInput(device: device)
//                if session.canAddInput(input){
//                    session.addInput(input)
//                }
//
//                if session.canAddOutput(output){
//                    session.addOutput(output)
//                }
//
//                previewLayer.videoGravity = .resizeAspectFill
//                previewLayer.session = session
//                session.startRunning()
//                self.captureSession = session
//
//            } catch  {
//                print(error)
//            }
//        }
//    }
    
//    @objc private func didTapTakePhoto(){
//        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
//
//
//    }
    
//    func captureOutput(_ output: AVcaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
//        //print("Camera was able to capture a frame:", Date())
//
//        guard let model = try? VNCoreMLModel(for: food().model) else{return}
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
//
//        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
//            guard let result = finishedReq.results as? [VNClassificationObservation] else {return}
//
//            guard let firstObservation = result.first else {return}
//            print(firstObservation.identifier, firstObservation.confidence)
//        }
//
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//    }
    

    
//    func pindahVC(image : UIImage){
//        let storyboard = UIStoryboard(name: "FoodDetail", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "FoodNameViewController") as! FoodNameViewController
//        vc.imageHasilFoto = image
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
//    @IBAction func BackToMain(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "JournalViewController", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "JournalViewController") as! JournalViewController
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if(segue.identifier == "goToFoodNameVC"){
//        let foodNameVC = segue.destination as? FoodNameViewController
//        foodNameVC?.imageHasilFoto = imageSend
//        }
//    }
}


//extension FoodRecogVC : AVCapturePhotoCaptureDelegate{
//
//
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        //print("PHOTO OUTPUT \(photo.fileDataRepresentation())")
//        guard let data = photo.fileDataRepresentation() else{
//            return
//        }
//        guard let image = UIImage(data: data) else {return}
//        captureSession?.stopRunning()
//
//        self.imageSend = image
//
//
////        pindahVC(image: image)
//
//        //let imageView = UIImageView(image: image)
//        //imageView.contentMode = .center
//        //let screenSize: CGRect = UIScreen.main.bounds
//        //imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height * 0.2)
//        //view.addSubview(imageView)
//
//
//    }
//
//
//}


extension FoodRecogVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
}


