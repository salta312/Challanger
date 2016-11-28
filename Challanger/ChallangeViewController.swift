//
//  ChallangeViewController.swift
//  Challanger
//
//  Created by Saltanat Aimakhanova on 11/28/16.
//  Copyright © 2016 saltaim. All rights reserved.
//

import UIKit
import Firebase
import Cartography

class ChallangeViewController: UIViewController {
    var challange: Challange!
    let storage = FIRStorage.storage()

    override func viewDidLoad() {
        super.viewDidLoad()
        let v = createView()
        view.addSubview(v)
        view.backgroundColor = UIColor.white
        constrain(v, view){
            v, view in
            v.top == view.top
            v.width == view.width
            v.centerX == view.centerX
            v.height == 150
        }

        // Do any additional setup after loading the view.
    }
    func createView()-> UIView{
        let storageRef = storage.reference(forURL: "gs://challanger-a8042.appspot.com/")
        var v = UIView()
        v.backgroundColor = UIColor.white
        var img = UIImage(named: "nop")
        var imgView = UIImageView(image: img)
           var nameLabel = UILabel()
        nameLabel.text = challange.name
        var descrLabel = UITextView()
        descrLabel.text = challange.descr
        v.addSubview(nameLabel)
        v.addSubview(imgView)
        v.addSubview(descrLabel)
        constrain(nameLabel, imgView, descrLabel, v){
            nameLabel, imgView, descrLabel, v in
            nameLabel.top == v.top + 64
            nameLabel.width == v.width
            nameLabel.centerX == v.centerX
            nameLabel.height == 20
            imgView.top == nameLabel.bottom + 20
            imgView.centerX == v.centerX
            imgView.width == v.width - 100
            imgView.height == 50
            descrLabel.top == imgView.bottom + 20
            descrLabel.centerX == v.centerX
            descrLabel.width == v.width
            descrLabel.height == 30
            
        }
        guard let ur = challange.imageRef else{
            return v
        }
        let starRef = storageRef.child(ur)
        DispatchQueue.main.async {
            starRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    print(error)
                    return
                }
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, responce, error) in
                    if error != nil{
                        print(error)
                        return;
                    }
                    imgView.image = UIImage(data: data!)
                }).resume()
            })
        }

        
        return v
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
