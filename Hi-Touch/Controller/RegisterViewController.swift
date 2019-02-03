//
//  RegisterViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/02.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func RegisterButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (result, error) in
            if error != nil{
                SVProgressHUD.dismiss()
                
                let alert = UIAlertController(title: "エラー", message: "メールアドレスかパスワードが有効ではありません", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
                print("Could not sign in: \(String(describing: error))")
            }else{
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    if error != nil{
                        print("Could not send Email!")
                    }else{
                        print("Sent Message!!")
                    }
                })
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToVerify", sender: self)
            }
        }
    }
}
