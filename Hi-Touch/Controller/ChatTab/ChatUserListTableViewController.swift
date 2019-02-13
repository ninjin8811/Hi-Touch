//
//  ChatUserListTableViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/12.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import RealmSwift

class ChatUserListTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var users: Results<ChatUserProfile>?
    
    var addedUsername = "name"
    var avatarImage: UIImage?{
        didSet{
//            performSegue(withIdentifier: "goToChat", sender: self)
        }
    }
    
    @IBOutlet var userListTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        userListTableView.register(UINib(nibName: "ChatUserCell", bundle: nil), forCellReuseIdentifier: "userCell")
    }


    
/*-----------------------------------------------------------------------------------------*/
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! ChatUserCell
        
        cell.nameLabel?.text = users?[indexPath.row].name ?? "No Users"
    
//        if let image = avatarImage{
//            cell.avatarImageView.image = image
//        }
//
//        cell.nameLabel.text = addedUser.name
        
        return cell
    }
    
    
/*-----------------------------------------------------------------------------------------*/
    //MARK: Data Manipulate Methods
    
    func loadUsers(){
        users = realm.objects(ChatUserProfile.self)
        tableView.reloadData()
    }
    
    func save(){
        
    }

    
    
    
/*-----------------------------------------------------------------------------------------*/
    //MARK: - before Moving to ChatView Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToChat"{
            
        }
    }

}
