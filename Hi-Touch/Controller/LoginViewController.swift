//
//  LoginViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/02.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil{
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "エラー", message: "メールアドレスかパスワードが有効ではありません", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                print("Could not create a user: \(String(describing: error))")
            }else{
                SVProgressHUD.dismiss()
                
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "goToMain", sender: self)
            }
        }
        
    }
    
}
