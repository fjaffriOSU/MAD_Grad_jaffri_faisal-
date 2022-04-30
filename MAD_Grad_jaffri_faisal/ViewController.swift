//
//  ViewController.swift
//  MAD_Grad_jaffri_faisal
//
//  Created by Faisal Jaffri on 4/29/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var myImageView: UIImageView!
    
    let myImagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myImagePicker.delegate = self
        myImagePicker.sourceType = .camera
        myImagePicker.allowsEditing = true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            myImageView.image = userImage
            guard let ciImage = CIImage(image: userImage) else {
                fatalError("Could not convert to CIImage")
            }
            detectImage(image: ciImage)
        }
        if let userImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            myImageView.image = userImage
            guard let ciImage = CIImage(image: userImage) else {
                fatalError("Could not convert to CIImage")
            }
            detectImage(image: ciImage)
        }
        
       
        
        
        myImagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func detectImage(image: CIImage){
        
        guard let my_model =  try? VNCoreMLModel(for: MyBoxcarImageClassifier().model) else{
            fatalError("Core ML model failed")
        }
        let request = VNCoreMLRequest(model: my_model) { vnRequest, error in
            guard let result = vnRequest.results as? [VNClassificationObservation] else{
                fatalError("Failed to process image")
            }
            print(result)
            
            if let highest_confidence = result.first{
                
               
                if highest_confidence.identifier.contains("graphiti"){
                    self.navigationItem.title = "boxcar contains graphitti!"
    
                }
                if highest_confidence.identifier.contains("new"){
                    self.navigationItem.title = "New boxcar"
    
                }
                if highest_confidence.identifier.contains("old"){
                    self.navigationItem.title = "Old boxcar!"
    
                }
                if highest_confidence.identifier.contains("damaged"){
                    self.navigationItem.title = "Damaged/wornout boxcar!"
    
                }
                if highest_confidence.identifier.contains("rusty"){
                    self.navigationItem.title = "Rusty boxcar!"
    
                }
               
            }
        }
        
        let myImageHandler = VNImageRequestHandler(ciImage: image)
        do{
            try myImageHandler.perform([request])
            
            
        }
        catch{
            print(error)
        }
        
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(myImagePicker, animated: true, completion: nil)
        
    }
    
  
    
}

