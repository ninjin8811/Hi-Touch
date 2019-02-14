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
        
        if let image = avatarImage {
            profileImageView.image = image
        }
        nameLabel.text = profileData.name
    }
    
    @IBAction func sendMessageButtonPressed(_ sender: UIButton) {
        guard let destinationVC = self.tabBarController?.viewControllers![1] as? UINavigationController else {
            preconditionFailure("タブバーを取得できませんでした")
        }
        tabBarController?.selectedViewController = destinationVC
        guard let vc = destinationVC.viewControllers[0] as? ChatUserListTableViewController else {
            preconditionFailure("チャットユーザーのビューが取得できませんでした")
        }
        destinationVC.popToViewController(vc, animated: true)
        
        vc.addedUsername = profileData.name
        
        if let image = avatarImage {
            vc.avatarImage = image
        }
    }
}
