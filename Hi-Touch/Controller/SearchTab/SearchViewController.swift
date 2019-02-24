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
            
            initAvatarArray()
            loadAvatarImages()
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
        cell.genderLabel.text = searchedData[indexPath.row].gender
        
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
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectedProfile" {
            let destinationVC = segue.destination as! UserProfileViewController
            
            destinationVC.profileData = searchedData[selectedIndex]
            destinationVC.avatarImage = avatarImages[selectedIndex]
        }
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - load Images
    
    func initAvatarArray() {
        avatarImages.removeAll()
        for _ in 0 ... searchedData.count - 1 {
            avatarImages.append(nil)
        }
        tableView.reloadData()
    }
    
    func loadAvatarImages() {
        for i in 0 ... searchedData.count - 1 {
            avatarImages[i] = nil

            guard let imageURL = URL(string: searchedData[i].imageURL) else{
                preconditionFailure("StringからURLに変換できませんでした！")
            }
            let request = ImageRequest(url: imageURL, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill)
            Nuke.ImagePipeline.shared.loadImage(with: request, progress: nil, completion: { (data, error) in
                if error != nil {
                    print("画像をダウンロードできませんでした！")
                    self.avatarImages[i] = UIImage(named: "alien")?.af_imageRoundedIntoCircle()
                } else {
                    print("画像をダウンロードしました！")
                    guard let image = data?.image else {
                        preconditionFailure("ダウンロードデータに画像がありませんでした！")
                    }
                    self.avatarImages[i] = image.af_imageRoundedIntoCircle()
                }
            })
            
//            let urlRequest = URLRequest(url: imageURL)
//
//            if let cachedAvatarImage = imageCache.image(for: urlRequest, withIdentifier: searchedData[i].imageURL){
//                print("キャッシュから画像をとってきました！")
//                avatarImages[i] = cachedAvatarImage
//
//            }else{
//                Alamofire.request(urlRequest).responseImage(completionHandler: { (data) in
//                    if let image = data.result.value{
//                        print("画像をダウンロードしました！")
//                        self.avatarImages[i] = image.af_imageRoundedIntoCircle()
//                        imageCache.add(image, for: urlRequest, withIdentifier: self.searchedData[i].imageURL)
//                        print("画像をキャッシュに追加しました")
//                    }else{
//                        print("画像をダウンロードできませんでした！")
//                    }
//                    self.tableView.reloadData()
//                })
//            }
        }
    }
}
