//
//  AccountTableViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/03.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import CodableFirebase
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SVProgressHUD
import UIKit
import AlamofireImage
import Nuke

class AccountTableViewController: UITableViewController {
    
    @IBOutlet var accountTableView: UITableView!
    
    var db: Firestore!
    var profileData = Profile()
    let secondArray = ["予定", "フレンド", "お気に入り", "アカウント設定"]
    let sectionTitle = ["プロフィール", "アカウント情報"]
    var avatarImage = UIImage(named: "profile-default")?.af_imageRoundedIntoCircle() {
        didSet {
            tableView.reloadData()
        }
    }
    var userID = "default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = Auth.auth().currentUser?.uid {
            userID = id
        } else {
            print("ユーザーIDを取得できませんでした！")
        }
        
        //Settings to cache images
        // 1
        DataLoader.sharedUrlCache.diskCapacity = 0
        
        let pipeline = ImagePipeline {
            // 2
            let dataCache = try! DataCache(name: "com.hi-touch.datacache", filenameGenerator: {
                return $0.sha1
            })
            // 3
            dataCache.sizeLimit = 200 * 1024 * 1024
            
            // 4
            $0.dataCache = dataCache
        }
        // 5
        ImagePipeline.shared = pipeline
        
        let contentMode = ImageLoadingOptions.ContentModes(success: .scaleAspectFill, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
        ImageLoadingOptions.shared.contentModes = contentMode
        ImageLoadingOptions.shared.placeholder = UIImage(named: "alien")
        ImageLoadingOptions.shared.failureImage = UIImage(named: "alien")
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.5)
        
        db = Firestore.firestore()
        accountTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        DataLoader.sharedUrlCache.diskCapacity = 0 //Disable the default disk cache
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
            
            if profileData.imageURL != "default" {
                guard let imageURL = URL(string: profileData.imageURL) else{
                    preconditionFailure("StringからURLに変換できませんでした！")
                }
                
                let request = ImageRequest(url: imageURL, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill)
                Nuke.loadImage(with: request, into: profileCell.profileImageView)
            }
            
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
            destinationVC.userID = userID
            destinationVC.profileData = profileData
        }
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - Data Manipulate Methods
    
    func loadProfile() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        
        db.collection("users").document(userID).getDocument { (snapshot, error) in
            if error != nil {
                print("データの取得に失敗しました！")
            } else {
                guard let snap = snapshot else {
                    preconditionFailure("データがありませんでした！")
                }
                if snap.exists {
                    //When User Data Exist
                    guard let value = snap.data() else {
                        preconditionFailure("取得したスナップショットにデータがありませんでした！")
                    }
                    do {
                        print("データをロードしました！")
                        self.profileData = try FirestoreDecoder().decode(Profile.self, from: value)
//                        self.downloadImage()
                        self.tableView.reloadData()
                    } catch {
                        print("取得したデータのデコードに失敗しました！")
                    }
                    //if fetched Data from cache
                    if snap.metadata.isFromCache {
                        print("キャッシュからデータをロードしました！")
                    }
                } else {
                    //User data was not exist
                    print("ドキュメントにデータがありませんでした！")
                }
            }
        }
    }
    
    
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            let ud = UserDefaults.standard
            ud.removeObject(forKey: "userData")
            dismiss(animated: true, completion: nil)
        } catch {
            print("ログアウト失敗！")
        }
    }
}
