//
//  ViewController.swift
//  seefood
//
//  Created by Arpit Singh on 23/07/18.
//  Copyright © 2018 Arpit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD
import VisualRecognitionV3
import Social

class ViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
  let imagePicked = UIImagePickerController()
    let url = "https://gateway.watsonplatform.net/visual-recognition/api"
    
//    "iam_apikey_description": "Auto generated apikey during resource-key operation for Instance - crn:v1:bluemix:public:watson-vision-combined:us-south:a/f07c6192d7564a3e94b391927d1ac4f6:da8b5b1a-eeda-415e-bc3d-26cc83318cab::",
//    "iam_apikey_name": "auto-generated-apikey-b43aa291-1849-4815-90bb-ec359cfe01da",
//    "iam_role_crn": "crn:v1:bluemix:public:iam::::serviceRole:Manager",
//    "iam_serviceid_crn": "crn:v1:bluemix:public:iam-identity::a/f07c6192d7564a3e94b391927d1ac4f6::serviceid:ServiceId-1f99b90f-caa1-41b5-aa49-ac904b8acc6a",
//    "url": "https://gateway.watsonplatform.net/visual-recognition/api"
    var classfication : [String] = []
    let version = "2018-06-21"
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var camerButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicked.delegate = self
        imagePicked.allowsEditing = false
        setenv("CFNETWORK_DIAGNOSTICS", "3", 1);
        share.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Share(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
        {
            navigationController?.navigationBar.isTranslucent = true
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc?.setInitialText("i found \(String(describing: navigationItem.title))")
            vc?.add(#imageLiteral(resourceName: "icons8-table-50"))
            present(vc!, animated: true, completion: nil)
        }else
        {
            self.navigationItem.title = "! please log in to twitter"
            self.navigationController?.navigationBar.barTintColor = UIColor.red
        }
    }
    @IBAction func camera(_ sender: UIBarButtonItem) {
        imagePicked.sourceType = .camera
        present(imagePicked, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        camerButton.isEnabled = false
        SVProgressHUD.show()
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageView.image = image
           imagePicked.dismiss(animated: true, completion: nil)
           let visual = VisualRecognition(version: version, apiKey: apikey)
        
            visual.classify(image: image) { (classifedImage) in
                let classes = classifedImage.images.first!.classifiers.first!.classes
                self.classfication = []
                for index in 0..<classes.count
                {
                    self.classfication.append(classes[index].className)
                    
                }
                
                print(self.classfication)
                DispatchQueue.main.async {
                   self.camerButton.isEnabled = true
                    SVProgressHUD.dismiss()
                    self.share.isHidden = false
                }
                DispatchQueue.main.async
                    {
                    self.navigationItem.title = self.classfication[0]
                    self.navigationController?.navigationBar.barTintColor = UIColor.green
                    self.navigationController?.navigationBar.isTranslucent = false
                }
            }
        }
    }
}

