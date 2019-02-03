//
//  VerifyViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/03.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import Firebase

class VerifyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func verifyButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "エラー", message: "認証が確認できません", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
    }
    
}
