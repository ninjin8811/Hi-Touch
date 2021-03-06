//
//  SetTermsViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/09.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import CodableFirebase
import Firebase
import FirebaseFirestore
import UIKit

class SetTermsViewController: UIViewController{
    
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    
    var db: Firestore!
    var list = [Profile]()
    var userID: String?
    let gender = ["男", "女", "他"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid{
            userID = uid
        }else{
            print("ユーザーIDが取得できませんでした")
        }
        
        db = Firestore.firestore()
    }
    
    
    /*-----------------------------------------------------------------------------------------*/
    // Search User Methods
    
    func searchFirebaseDatabase(child: [String], equelValue: [String]) {

        var ref = db.collection("users") as Query

        for i in 0..<child.count {
            let temp = ref.whereField(child[i], isEqualTo: equelValue[i])
            ref = temp
        }
        ref.getDocuments { (snapshots, error) in
            if error != nil {
                print("ユーザーの検索に失敗しました！")
            } else {
                guard let snap = snapshots else {
                    preconditionFailure("データの取得に失敗しました！")
                }
                for document in snap.documents {
                    do {
                        let data = try FirestoreDecoder().decode(Profile.self, from: document.data())
                        self.list.append(data)
                    } catch {
                        print("取得したデータのデコードに失敗しました！")
                    }
                }
            }
            self.goToPreviousView()
        }
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - View Will Desappear
    
    func goToPreviousView() {
        let nav = navigationController
        let nextVC = nav?.viewControllers[(nav?.viewControllers.count)! - 2] as! SearchViewController
        
        nextVC.searchedData = list
        
        navigationController?.popViewController(animated: true)
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - Button Action
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        list.removeAll()
        
        var childList = [String]()
        var equalValueList = [String]()
        
        DispatchQueue.main.async {
            if self.teamTextField.text! != "" {
                childList.append("team")
                equalValueList.append(self.teamTextField.text!)
            }
            if self.regionTextField.text != "" {
                childList.append("region")
                equalValueList.append(self.regionTextField.text!)
            }
            if self.ageTextField.text != "" {
                childList.append("age")
                equalValueList.append(self.ageTextField.text!)
            }
            if self.genderTextField.text != "" {
                childList.append("gender")
                equalValueList.append(self.genderTextField.text!)
            }
            self.searchFirebaseDatabase(child: childList, equelValue: equalValueList)
        }
    }
}
