//
//  ChallangesViewController.swift
//  Challanger
//
//  Created by Saltanat Aimakhanova on 11/7/16.
//  Copyright © 2016 saltaim. All rights reserved.
//

import UIKit
import Cartography
import Firebase
import SwiftyJSON

protocol MyVCProtocol{
    func receiveDataFromDb()
}
class ChallangesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MyVCProtocol{
    var search = UISearchController(searchResultsController: nil)
    var button = UIButton()
    let storage = FIRStorage.storage()
    var ref:FIRDatabaseReference!
    let database = FIRDatabase.database().reference()
    var challanges = [Challange]()
    var tableView: UITableView = UITableView()
    var searchedChallanges = [Challange]()
    var isSearched = false
    //let storageRef = storage.referenceForURL("gs://<your-firebase-storage-bucket>")
   // var delegate: MyVCProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       // tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = search.searchBar
        self.view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        ref = FIRDatabase.database().reference()
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(showAnAlert), for: .touchUpInside)
        //view.addSubview(search.searchBar)
        view.addSubview(button)
        view.addSubview(tableView)

        constrain(button, tableView, view){
            button, tableView, view in
           // search.width == view.width
           // search.left == view.left
           // search.height == 20
           // search.top == view.top + 64
            button.bottom == view.bottom
            button.width == view.width
            button.left == view.left
            tableView.top == view.top + 80
            tableView.left == view.left
            tableView.right == view.right
            //tableView.width == view.width
            tableView.bottom == button.top
            
        }
        self.receiveDataFromDb()
        // Do any additional setup after loading the view.
    }
    func showAnAlert(){
        var vc = NewChallangeVC()
        vc.deletegate = self
        self.navigationController?.pushViewController(vc, animated: true)
       // self.present(NewChallangeVC(), animated: true, completion: nil)
//        var alert = UIAlertController(title: "Alert", message: "Enter website that you would like to block", preferredStyle: UIAlertControllerStyle.alert)
//       // var name = UITextField()
//        //name.placeholder = "name"
//        alert.addTextField { (name) in
//            
//        }
//         var descr = UITextView()
//        //alert.add
//       // alert.addTextField(configurationHandler: <#T##((UITextField) -> Void)?##((UITextField) -> Void)?##(UITextField) -> Void#>)
//       // alert.addChildViewController(UITextView())
//        var b1 = UIAlertAction(title: "upload a photo", style: .default) { (action) in
//            self.showImagePicker()
//        }
//      //  b1.setTitle("upload a photo", for: .normal)
//     //   b1.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
//        alert.addAction(b1)
//        self.present(alert, animated: true, completion: nil)
    }
    func showImagePicker(){
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
        var v1 = UIImageView(image: selectedImage)
        view.addSubview(v1)
        constrain(view, v1){
            view, v1 in
            v1.width == 50
            v1.height == 50
            v1.centerX == view.centerX
            v1.centerY == view.centerY
        }
        self.dismiss(animated: true, completion: nil)
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        searchedChallanges = challanges.filter({ (challange) -> Bool in
            return challange.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    func receiveDataFromDb(){
        //var j: [String: [AnyObject]]?
        database.child("challanges").observe(FIRDataEventType.value, with: { (snapshot) in
            //let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            // ...
            //print(<#T##items: Any...##Any#>)
            var j = snapshot.value
            var j1 = JSON(j)
            //print(j1.dictionaryValue)
            for item in j1.dictionaryValue{
              //  print(item.key)
                var owner = item.key
                //c.challangeOwnerId = item.key
               // print(item.value)
                var j2 = item.value
                //print(j2.dictionary)
                guard let j4 = j2.dictionary else{
                    return
                }
                for index in j4{
                    var c = Challange()
                    c.challangeOwnerId = owner
                    //print(index.key)
                    c.challangeId = index.key
                    //print(index.value)
                    do{
                        c.descr = index.value["descr"].stringValue
                        c.name = index.value["name"].stringValue
                        c.imageRef = index.value["imageRef"].stringValue
                        print("\(c.descr) \(c.name)")
                        self.challanges.append(c)
                        
                    }catch let myJSONError {
                        print(myJSONError)
                    }
                }
                self.tableView.reloadData()

                //print(item.value)
            }
            
          //  print(j)
        })


    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if search.isActive && search.searchBar.text != ""{
            return self.searchedChallanges.count
        }
            return self.challanges.count
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    var name: String!
    
    var ch: Challange!
    var ur: String?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Code here
        let storageRef = storage.reference(forURL: "gs://challanger-a8042.appspot.com/")
        
         let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")

       // let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
       // let cell = MyTableViewCell(challange: self.challanges[(indexPath as NSIndexPath).item], style: .default, reuseIdentifier: "cell")
        if search.isActive && search.searchBar.text != ""{
            name = self.searchedChallanges[(indexPath as NSIndexPath).item].name
           // ch = self.searchedChallanges[(indexPath as NSIndexPath).item]
            ur = self.searchedChallanges[(indexPath as NSIndexPath).item].imageRef
        }else{
            name = self.challanges[(indexPath as NSIndexPath).item].name
           // ch = self.challanges[(indexPath as NSIndexPath).item]
            ur = self.challanges[(indexPath as NSIndexPath).item].imageRef
        }
        print(self.challanges[(indexPath as NSIndexPath).item].name)
       // let cell = MyTableViewCell(challange: ch, style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = name
        cell.imageView?.image = UIImage(named: "nop")
        guard ur != nil else{
            return cell;
        }
        let starRef = storageRef.child(ur!)
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
                    cell.imageView?.image = UIImage(data: data!)
                }).resume()
            })
        }

      //  cell.delegate = self;
        // let cell = MyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        // cell.site = arr[(indexPath as NSIndexPath).item]
        
        // let cell1 = MyTableViewCell();
        
        // let cell = MyTableV
        //cell.t
        //let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell")
        //cell.textLabel?.text = "Hello"
        //cell.textLabel?.text = arr[(indexPath as NSIndexPath).item]
        return cell;
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
extension ChallangesViewController: UISearchResultsUpdating {
   // @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
      //  isSearched = true
        //hello
        filterContentForSearchText(searchText: search.searchBar.text!)
    }


    
}
