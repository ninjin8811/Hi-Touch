//
//  AccountTableViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/03.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class AccountTableViewController: UITableViewController {
    
    let realm = try! Realm()
    let dataRef = Database.database().reference().child("users")
    var profileRealm = Profile()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var accountTableView: UITableView!
    
    let profileData = ProfileCell()
    let secondArray = ["予定", "フレンド", "お気に入り", "アカウント設定"]
    let sectionTitle = ["プロフィール", "アカウント情報"]
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = realm.objects(Profile.self).first{
            profileRealm = data
        }else{
            print("データない！")
        }
        
//        isExistAutoID()
        
        loadProfile()
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AccountTableViewController.imageViewTapped(_:))))
        
        accountTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
    }
    
    
    
    
    
    
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitle.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitle[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
            
        case 1:
            return secondArray.count
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
            
            profileCell.nameLabel.text = profileRealm.name
            profileCell.ageLabel.text = String(profileRealm.age)
            profileCell.regionLabel.text = profileRealm.region
            profileCell.teamLabel.text = profileRealm.team
            
            return profileCell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountViewCell", for: indexPath)
            cell.textLabel?.text = secondArray[indexPath.row]
            
            return cell
        }
    }
    
    
    
    
    
    
    

    //MARK: - Check Exist Method
    
//    func isExistAutoID(){
//
//        if profileRealm.autoID != nil{
//
//            print("オートIDありました！")
//            loadProfile()
//
//        }else{
//
//            print("オートIDないです作ります！")
//            dataRef.child("users").childByAutoId()
//            try! realm.write {
//                profileRealm.autoID = dataRef.child("users").childByAutoId()
//            }
//
//        }
//
//        print(profileRealm)
//    }

    
    //MARK: - Load Data Method
    
    func loadProfile(){
        
        if let uid = profileRealm.userID {
            
            dataRef.child(uid).observe(DataEventType.value, with: { (snapshot) in           //ここはいらないかも
                
                let snapshotValue = snapshot.value as! [String: AnyObject]

                
                
            })
        }
        
        if profileRealm.userID != nil{
            
        }else{
            guard let userID = Auth.auth().currentUser?.uid else {
                fatalError()
            }
            
            profileRealm.userID = userID
        }
        
        
    }
    
    //MARK: - Initialize Firebase Database
    
    func initProfileOnFirebase(){
        

        
        
    }
    
}









//MARK: - Select Profile Image Method

extension AccountTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer){
        
        let pickerView = UIImagePickerController()
        
        let alert = UIAlertController(title: "プロフィール画像を選んでください", message: "", preferredStyle: .actionSheet)
        let launchCameraAction = UIAlertAction(title: "カメラを起動", style: .default) { (action) in
            
            pickerView.sourceType = .camera
            self.present(pickerView, animated: true, completion: nil)
        }
        let pickAction = UIAlertAction(title: "カメラロールから選択", style: .default) { (action) in
            
            pickerView.sourceType = .photoLibrary
            self.present(pickerView, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alert.addAction(launchCameraAction)
        alert.addAction(pickAction)
        alert.addAction(cancelAction)
        
        pickerView.allowsEditing = true
        pickerView.delegate = self
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profileImageView.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
