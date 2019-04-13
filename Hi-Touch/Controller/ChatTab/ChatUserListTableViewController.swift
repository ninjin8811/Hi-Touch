//
//  ChatUserListTableViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/12.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import FirebaseStorage
import RealmSwift
import Nuke
import UIKit

class ChatUserListTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var users: Results<ChatUser>?
    var addedUserName = "name"
    var addedUserID: String? {
        didSet {
//            searchExsistingUser(userID: addedUserID!)
//            performSegue(withIdentifier: "goToChat", sender: self)
        }
    }
    var avatarImageURL = "url"
    
    @IBOutlet var userListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //Settings to load images
        let contentMode = ImageLoadingOptions.ContentModes(success: .scaleAspectFill, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
        ImageLoadingOptions.shared.contentModes = contentMode
        ImageLoadingOptions.shared.placeholder = UIImage(named: "alien")
        ImageLoadingOptions.shared.failureImage = UIImage(named: "alien")
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.5)
        
        userListTableView.register(UINib(nibName: "ChatUserCell", bundle: nil), forCellReuseIdentifier: "chatUserCell")
        
        print("ロード！！！！！！！")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadUsers()
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatUserCell", for: indexPath) as! ChatUserCell
        
        cell.nameLabel.text = users?[indexPath.row].name
        cell.messageLabel.text = users?[indexPath.row].recentMessage
        cell.timeLabel.text = users?[indexPath.row].time
        
        guard let urlString = users?[indexPath.row].imageURL else {
            preconditionFailure("ユーザーデータにイメージURLがありませんでした！")
        }
        guard let imageURL = URL(string: urlString) else{
            preconditionFailure("StringからURLに変換できませんでした！")
        }
        
        let request = ImageRequest(url: imageURL, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill)
        Nuke.loadImage(with: request, into: cell.avatarImageView)

        return cell
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - Data Manipulate Methods
    
    func loadUsers() {
        users = realm.objects(ChatUser.self)
        tableView.reloadData()
    }
    
    func save(user: ChatUser) {
        do{
            try realm.write {
                realm.add(user)
            }
        }catch{
            print("Error:\(error)")
        }
        tableView.reloadData()
    }
    
    
    // MARK: - When this page moved from UserProfileView
    func searchExsistingUser(userID: String) {
        print("サーチ！！")
        
        let newUser = ChatUser()
        newUser.name = addedUserName
        newUser.imageURL = avatarImageURL
        newUser.userID = userID
        save(user: newUser)
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - before Moving to ChatView Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChat" {}
    }
}
