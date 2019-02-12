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
    
    var userList = [Profile]()
    var avatarImage: UIImage?{
        didSet{
            performSegue(withIdentifier: "goToChat", sender: self)
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
        return userList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! ChatUserCell
        
        if let image = avatarImage{
            cell.avatarImageView.image = image
        }
        
        return cell
    }
    
    
    
/*-----------------------------------------------------------------------------------------*/
    //MARK: - before Moving to ChatView Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToChat"{
            
        }
    }

}
