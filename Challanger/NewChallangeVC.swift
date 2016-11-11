//
//  NewChallangeVC.swift
//  Challanger
//
//  Created by Saltanat Aimakhanova on 11/8/16.
//  Copyright © 2016 saltaim. All rights reserved.
//

import UIKit
import Cartography
import Firebase

class NewChallangeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var img: UIImage!
    var imgView: UIImageView!
    var textField:UITextField!
    var textView: UITextView!
    var button = UIButton();
    let storage = FIRStorage.storage()
    var imgName:String!
    let database = FIRDatabase.database().reference()
    var deletegate: MyVCProtocol!


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        img = UIImage.init(named: "nop")
        imgView = UIImageView(image: img)
        textView = UITextView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseAnImage))
        textField = UITextField()
        textField.placeholder = "name"
        button.setTitle("submit", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        //button.titleLabel?.textColor = UIColor.black
        //button.backgroundColor = UIColor.blue
        view.addSubview(imgView)
        view.addSubview(textField)
        view.addSubview(textView)
        view.addSubview(button)
        button.addTarget(self, action: #selector(upload), for: .touchUpInside)
        textView.layer.borderWidth = 1.0
        textView.text = "write description here ..."
        constrain(imgView, textField, textView, button, view){
            imgView, textField, textView, button, view in
            textField.top == view.top + 64
            //textField.width == view.width - 20
            //textField.centerX == view.centerX
            textField.height == 30
            imgView.top == textField.bottom + 10
            imgView.centerX == view.centerX
            imgView.width == view.width - 100
            imgView.height == 200
            textField.width == imgView.width
            textField.centerX == imgView.centerX
            textView.top == imgView.bottom + 10
            textView.width == imgView.width
            textView.centerX == imgView.centerX
            textView.height == 75
            button.top == textView.bottom + 10
            button.centerX == view.centerX
            button.height == 20
            button.width == textView.width
        }
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tap)


        // Do any additional setup after loading the view.
    }
    func chooseAnImage(){
    
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgView.image = selectedImage
        
        self.dismiss(animated: true, completion: nil)
    }
    func upload(){
        let storageRef = storage.reference(forURL: "gs://challanger-a8042.appspot.com/")
        let imgRef = storageRef.child("images").child((FIRAuth.auth()?.currentUser?.uid)!).child(UUID().uuidString)
        var data = Data()
        data = UIImageJPEGRepresentation(imgView.image!, 0.8)!
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
       // imgRef.put(data, metadata: <#T##FIRStorageMetadata?#>)
        imgRef.put(data, metadata: metaData) { (dat, error) in
            if error != nil{
                self.showAlert(message: error.debugDescription)
                return
            }
        }
        let challangesRef = database.child("challanges").child((FIRAuth.auth()?.currentUser?.uid)!).child(UUID().uuidString)
        guard let name = textField.text else{
            self.showAlert(message: "no name provided")
            return
        }
        guard let descr = textView.text else{
            self.showAlert(message: "no description provided")
            return
        }
        var dict = ["name": name, "descr": descr, "imageRef": imgRef.fullPath]
     //   print("My name is \(name)")
    //    print("My description is \(descr)")
        challangesRef.setValue(dict)
       // self.dismiss(animated: true, completion: nil)
        deletegate.receiveDataFromDb()
        self.navigationController?.popViewController(animated: true)
     //   let metaData = FIRStorageMetadata()


    }
    func showAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigationdata

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
