//
//  HasilFotoVC.swift
//  Healco
//
//  Created by Ericson Hermanto on 17/06/21.
//

import UIKit
import Foundation
import AVKit
import Vision

class HasilFotoVC: UIViewController {
    var imageHasilFoto : UIImage!
    
    @IBOutlet weak var fotoHasilImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fotoHasilImageView.image = imageHasilFoto
        
        fotoHasilImageView.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
        
        analyzeImage(image: imageHasilFoto)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            print("Camera was able to capture a frame:", Date())

        guard let model = try? VNCoreMLModel(for: Food101(configuration: MLModelConfiguration.init()).model) else{return}
                   guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}

                   let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
                       guard let result = finishedReq.results as? [VNClassificationObservation] else {return}

                       guard let firstObservation = result.first else {return}
                       print(firstObservation.identifier, firstObservation.confidence)
                   }

                   try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    private func analyzeImage (image: UIImage?){
        guard let buffer = image?.resize(size: CGSize(width: 299, height: 299))?
                .getCVPixelBuffer() else {
            return
        }

        do {
            let config = MLModelConfiguration()
            let model = try Food101(configuration: config)
            let input = Food101Input(image:  buffer)

            let output = try model.prediction(input: input)
            let text = output.classLabel
            print("nama makanannya ", text)
        }
        catch {
            print(error.localizedDescription)
        }
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
