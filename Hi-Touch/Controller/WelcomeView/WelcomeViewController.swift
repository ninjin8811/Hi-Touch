//
//  WelcomeViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/02.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Auto Login
        if let userData = UserDefaults.standard.dictionary(forKey: "userData"){
            Auth.auth().signIn(withEmail: userData["email"] as! String, password: userData["password"] as! String, completion: { (result, error) in
                if error != nil {
                    print("ログインに失敗しました")
                    
                } else {
                    print("自動ログインしました")
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            })
        }
    }
}
