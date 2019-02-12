//
//  UserProfileViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/12.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    
    var profileData = Profile()
    var avatarImage: UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = avatarImage{
            profileImageView.image = image
        }
        nameLabel.text = profileData.name
    }

    @IBAction func sendMessageButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToChatUserList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ChatUserListTableViewController
        
        destinationVC.userList.append(profileData)
    }
    
}
