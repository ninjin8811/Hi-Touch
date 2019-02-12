//
//  SearchViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/09.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SearchViewController: UITableViewController {
    
    @IBOutlet var searchTableView: UITableView!
    
    var selectedIndex = 0
    var avatarImages = [UIImage?]()
    var searchedData = [Profile](){
        didSet{
            initAvatarArray()
            loadAvatarImages()
        }
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
    }
    
    
    
    
    
    
    @IBAction func check(_ sender: UIBarButtonItem) {
            tableView.reloadData()
    }
    

    
/*-----------------------------------------------------------------------------------------*/
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
        
        if let image = avatarImages[indexPath.row] {
            cell.profileImageView.image = image
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goToSelectedProfile", sender: self)
    }
    
/*-----------------------------------------------------------------------------------------*/
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToSelectedProfile"{
            
            let destinationVC = segue.destination as! UserProfileViewController
            
            destinationVC.profileData = searchedData[selectedIndex]
            destinationVC.avatarImage = avatarImages[selectedIndex]
        }
    }
    
    
    
/*-----------------------------------------------------------------------------------------*/
    //MARK: - load Images
    
    func initAvatarArray(){
        avatarImages.removeAll()
        for _ in 0...searchedData.count - 1{
            avatarImages.append(nil)
        }
        tableView.reloadData()
    }
    
    
    func loadAvatarImages(){
        
        for i in 0...searchedData.count - 1{
            
            avatarImages[i] = nil
            
            let imageRef = Storage.storage().reference().child("avatarImages").child("\(searchedData[i].userID).jpg")
            
            imageRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                
                if error == nil{
                    guard let imageData = data else{
                        return
                    }
                    
                    self.avatarImages[i] = UIImage(data: imageData)
                    
                    self.tableView.reloadData()
                }
            })
        }
    }

}
