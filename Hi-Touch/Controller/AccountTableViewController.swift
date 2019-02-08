//
//  AccountTableViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/03.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI
import SVProgressHUD

class AccountTableViewController: UITableViewController {
    
    var dataRef = Database.database().reference()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var accountTableView: UITableView!
    
    var profileData = Profile()
    let secondArray = ["予定", "フレンド", "お気に入り", "アカウント設定"]
    let sectionTitle = ["プロフィール", "アカウント情報"]
    var avatarImage = UIImage(named: "default.jpg")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AccountTableViewController.imageViewTapped(_:))))
        
        accountTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {

        loadProfile()
    }
    
    
    
    
    


    // MARK: - Table view delegate

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
            
            profileCell.nameLabel.text = profileData.name
            profileCell.ageLabel.text = profileData.age
            profileCell.regionLabel.text = profileData.region
            profileCell.teamLabel.text = profileData.team
            profileCell.profileImageView.image = avatarImage

            return profileCell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountViewCell", for: indexPath)
            cell.textLabel?.text = secondArray[indexPath.row]
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == [0, 0]{
            performSegue(withIdentifier: "goToProfileSetting", sender: self)
        }
        
        print("選択されたインデックスパス:\(indexPath)")
        print("indexpath.row:\(indexPath.row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueIdentifier = segue.identifier else {
            return
        }
        
        if segueIdentifier == "goToProfileSetting"{
            let destinationVC = segue.destination as! ProfileViewController
            destinationVC.hidesBottomBarWhenPushed = true
            destinationVC.proDataRef = dataRef
            destinationVC.profileData = profileData
        }
    }
    
    
    
    
    
    
    //MARK: - Data Manipulate Methods
    
    func saveData(){
        
        let profileDictionary = ["name": profileData.name, "age": profileData.age, "team": profileData.team, "region": profileData.region, "imageURL": profileData.imageURL]
        
        dataRef.setValue(profileDictionary) { (error, reference) in
            
            if error != nil{
                print("セーブできませんでした！")
            }else{
                print("セーブできました！")
            }
        }
    }
    
    func loadProfile(){
        
        guard let userID = Auth.auth().currentUser?.uid else{
            fatalError()
        }
        
        dataRef = Database.database().reference().child("users").child(userID)
        dataRef.keepSynced(true)
        
        dataRef.observe(DataEventType.value) { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary{
                
                print("ロード成功！")
                print(value)
                self.profileData.name = value["name"] as! String
                self.profileData.age = value["age"] as! String
                self.profileData.team = value["team"] as! String
                self.profileData.region = value["region"] as! String
                self.profileData.imageURL = value["imageURL"] as! String
                
                self.downloadImage(with: userID)
                
                print(self.profileData)
                
                self.tableView.reloadData()

            }else{
                print("データなかったです！")
            }
        }
    }
    
    func downloadImage(with userID: String){
        
        SVProgressHUD.show()

        let imageRef = Storage.storage().reference().child("avatarImages").child("\(userID).jpg")
        
//        profileImageView.sd_setImage(with: imageRef)
        
        imageRef.getData(maxSize: 7 * 1024 * 1024) { (data, error) in

            if error != nil{
                print("画像を取得できませんでした！")
            }else{
                print("画像をダウンロードしました！")
                
                guard let imageData = data else{
                    return
                }
                self.profileImageView.image = UIImage(data: imageData)
                self.avatarImage = UIImage(data: imageData)
                
                self.tableView.reloadData()
            }
        }
        SVProgressHUD.dismiss()
    }
    

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        saveData()
    }
    
}









//MARK: - Select Profile Image Method

extension AccountTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer){
        
        print("画像がタップされました！")
        
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
