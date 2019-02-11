//
//  SearchViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/09.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UITableViewController {
    
    @IBOutlet var searchTableView: UITableView!
    
    
    var searchedData = [Profile](){
        didSet{
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func check(_ sender: UIBarButtonItem) {
            tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        searchTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
    }
    
    func loadItems(){
        tableView.reloadData()
    }
    

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
        
        cell.ageLabel.text = searchedData[indexPath.row].age
        cell.nameLabel.text = searchedData[indexPath.row].name
        cell.regionLabel.text = searchedData[indexPath.row].region
        cell.teamLabel.text = searchedData[indexPath.row].team
        
        return cell
    }

}
