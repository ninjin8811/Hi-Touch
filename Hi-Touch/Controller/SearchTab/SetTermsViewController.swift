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
//    let dataRef = Database.database().reference().child("users")
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
    }
    
    
    /*-----------------------------------------------------------------------------------------*/
    // Search User Methods
    
    func searchFirebaseDatabase(child: [String], equelValue: [String]) {
        print("ああああああああ")
        print(child)
        print(equelValue)
        db.collection("users").getDocuments { (snapshots, error) in
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
            print(self.list)
        }
//
//        var ref: Query = db.collection("users")
//        print("いいいいいいい")
//        for i in 0..<child.count {
//            if let temp = ref.whereField(child[i], isEqualTo: equelValue[i]) as? CollectionReference {
//                ref = temp
//            }
//        }
//        ref.order(by: "team").getDocuments { (snapshots, error) in
//            if error != nil {
//                print("ユーザーの検索に失敗しました！")
//            } else {
//                guard let snap = snapshots else {
//                    preconditionFailure("データの取得に失敗しました！")
//                }
//                for document in snap.documents {
//                    do {
//                        let data = try FirestoreDecoder().decode(Profile.self, from: document.data())
//                        self.list.append(data)
//                    } catch {
//                        print("取得したデータのデコードに失敗しました！")
//                    }
//                }
//            }
////            self.goToPreviousView()
//        }



//        let ref = dataRef.queryOrdered(byChild: child).queryEqual(toValue: equelValue)
//
//        ref.observeSingleEvent(of: DataEventType.value, with: { snapshot in
//
//            for item in snapshot.children {
//                let snap = item as! DataSnapshot
//
//                guard let value = snap.value else {
//                    return
//                }
//                let data = try! FirebaseDecoder().decode(Profile.self, from: value)
//
//                self.narrowSearchedData(data)
//            }
//            if self.list.count == 0{
//                print("ユーザーを見つけられませんでした！")
//            }else{
//                self.goToPreviousView()
//            }
//
//        })
    }
    
    func narrowSearchedData(_ value: Profile) {
        
        if value.userID == userID{
            return
        }
        if genderTextField.text! != ""{
            if genderTextField.text! != value.gender{
                return
            }
        }
        if ageTextField.text! != "" {
            if ageTextField.text! != value.age {
                return
            }
        }
        if teamTextField.text! != "" {
            if teamTextField.text! != value.team {
                return
            }
        }
        if regionTextField.text! != "" {
            if teamTextField.text! != value.team {
                return
            }
        }
        
        list.append(value)
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
