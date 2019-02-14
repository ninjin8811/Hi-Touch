//
//  AccountTableViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/03.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import CodableFirebase
import Firebase
import FirebaseStorage
import FirebaseUI
import SVProgressHUD
import UIKit
import Alamofire
import AlamofireImage

class AccountTableViewController: UITableViewController {
    var dataRef = Database.database().reference()
    
    @IBOutlet var accountTableView: UITableView!
    
    var profileData = Profile()
    let secondArray = ["予定", "フレンド", "お気に入り", "アカウント設定"]
    let sectionTitle = ["プロフィール", "アカウント情報"]
    var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        print(path)
        accountTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        loadProfile()
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
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
        if indexPath.section == 0 {
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
            
            profileCell.nameLabel.text = profileData.name
            profileCell.ageLabel.text = profileData.age
            profileCell.regionLabel.text = profileData.region
            profileCell.teamLabel.text = profileData.team
            profileCell.genderLabel.text = profileData.gender
            profileCell.profileImageView.image = avatarImage
            
            return profileCell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountViewCell", for: indexPath)
            cell.textLabel?.text = secondArray[indexPath.row]
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == [0, 0] {
            performSegue(withIdentifier: "goToProfileSetting", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else {
            return
        }
        
        if segueIdentifier == "goToProfileSetting" {
            let destinationVC = segue.destination as! ProfileViewController
            destinationVC.hidesBottomBarWhenPushed = true
            destinationVC.proDataRef = dataRef
            destinationVC.profileData = profileData
            
            if let image = avatarImage {
                destinationVC.avatarImage = image
            } else {
                print("画像を渡せませんでした！")
            }
        }
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - Data Manipulate Methods
    
    func loadProfile() {
        guard let userID = Auth.auth().currentUser?.uid else {
            fatalError()
        }
        
        dataRef = Database.database().reference().child("users").child(userID)
        
        dataRef.keepSynced(true)
        
        dataRef.observe(DataEventType.value) { snapshot in
            if snapshot.exists() {
                guard let value = snapshot.value else {
                    return
                }
                do {
                    self.profileData = try FirebaseDecoder().decode(Profile.self, from: value)
                    self.profileData.userID = userID
                    self.downloadImage(with: userID)
                    self.tableView.reloadData()
                } catch {
                    preconditionFailure("デコードに失敗しました！")
                }
            } else {
                self.avatarImage = UIImage(named: "profile-default.jpg")
                print("保存されたデータがありませんでした！")
            }
            self.tableView.reloadData()
        }
    }
    
    func downloadImage(with userID: String) {
//        let downloader = ImageDownloader()
        let imageCache = AutoPurgingImageCache()

        guard let imageURL = URL(string: profileData.imageURL) else{
            preconditionFailure("StringからURLに変換できませんでした！")
        }
        let urlRequest = URLRequest(url: imageURL)
        
        if let cachedAvatarImage = imageCache.image(for: urlRequest, withIdentifier: profileData.imageURL){
            print("キャッシュから画像をとってきました！")
            avatarImage = cachedAvatarImage
            
        }else{
//            downloader.download(urlRequest, completion: { (data) in
//                                if let image = data.result.value{
//                                    print("画像をダウンロードしました！")
//                                    self.avatarImage = image
//                                    imageCache.add(image, for: urlRequest, withIdentifier: self.profileData.imageURL)
//                                    print("画像をキャッシュに追加しました")
//                                }else{
//                                    print("画像をダウンロードできませんでした！")
//                                }
//                                self.tableView.reloadData()
//
//            })
            Alamofire.request(urlRequest).responseImage(completionHandler: { (data) in
                if let image = data.result.value{
                    print("画像をダウンロードしました！")
                    self.avatarImage = image.af_imageRoundedIntoCircle()
                    imageCache.add(image, for: urlRequest, withIdentifier: self.profileData.imageURL)
                    print("画像をキャッシュに追加しました")
                }else{
                    print("画像をダウンロードできませんでした！")
                }
                self.tableView.reloadData()
            })
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("ログアウト失敗！")
        }
    }
}

