//
//  ChatTableViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/12.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import RealmSwift

class ChatTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var profileData = Profile()
    var messages: Results<Messages>?
    var selectedUser: ChatUser? {
        didSet {
            loadMessages()
        }
    }
    
    @IBOutlet var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - Data Maniplate Methods
    
    func loadMessages() {
        
    }
    
}
