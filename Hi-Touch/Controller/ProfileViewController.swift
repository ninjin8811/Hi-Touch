//
//  ProfileViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/06.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    
    var profileData = Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(profileData)
        
        nameTextField.text = profileData.name
        ageTextField.text = profileData.age
        teamTextField.text = profileData.team
        regionTextField.text = profileData.region
    }

    @IBAction func editButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}
