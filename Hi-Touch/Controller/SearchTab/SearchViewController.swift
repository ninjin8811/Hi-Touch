//
//  SearchViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/09.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import Firebase
import FirebaseStorage
import UIKit
import AlamofireImage
import Nuke

class SearchViewController: UITableViewController {
    @IBOutlet var searchTableView: UITableView!
    
    var selectedIndex = 0
    var avatarImages = [UIImage?]()
    var searchedData = [Profile]() {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        let contentMode = ImageLoadingOptions.ContentModes(success: .scaleAspectFill, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
        ImageLoadingOptions.shared.contentModes = contentMode
        ImageLoadingOptions.shared.placeholder = UIImage(named: "alien")
        ImageLoadingOptions.shared.failureImage = UIImage(named: "alien")
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.5)
        
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
        cell.genderLabel.text = searchedData[indexPath.row].gender

        guard let imageURL = URL(string: searchedData[indexPath.row].imageURL) else{
            preconditionFailure("StringからURLに変換できませんでした！")
        }
        
        let request = ImageRequest(url: imageURL, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill)
        Nuke.loadImage(with: request, into: cell.profileImageView)
        
//        if let image = avatarImages[indexPath.row] {
//            cell.profileImageView.image = image
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goToSelectedProfile", sender: self)
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectedProfile" {
            let destinationVC = segue.destination as! UserProfileViewController
            
            destinationVC.profileData = searchedData[selectedIndex]
            //ユーザープロフィールビューに画像を渡す処理を書く！
        }
    }
}
