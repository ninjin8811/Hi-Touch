//
//  VerifyViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/03.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import Firebase
import SVProgressHUD
import UIKit

class VerifyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func verifyButtonPressed(_ sender: UIButton) {
//        SVProgressHUD.show()
//
//        if Auth.auth().currentUser?.isEmailVerified == true{
//            SVProgressHUD.dismiss()
//
//            performSegue(withIdentifier: "goToMain", sender: self)
//            dismiss(animated: true, completion: nil)
//        }else{
//            SVProgressHUD.dismiss()
//
//            let alert = UIAlertController(title: "エラー", message: "認証が確認できません", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//            alert.addAction(okAction)
//            present(alert, animated: true, completion: nil)
//        }
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "goToMain", sender: self)
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if error != nil {
                print("Could not send Email")
            } else {
                print("Sent Message!!")
            }
        })
    }
}
