//
//  SetTermsViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/09.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import CodableFirebase
import Firebase
import UIKit

class SetTermsViewController: UIViewController{
    
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    
    let dataRef = Database.database().reference().child("users")
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
    
    func searchFirebaseDatabase(child: String, equelValue: String) {
        let ref = dataRef.queryOrdered(byChild: child).queryEqual(toValue: equelValue)
        
        ref.observeSingleEvent(of: DataEventType.value, with: { snapshot in
            
            for item in snapshot.children {
                let snap = item as! DataSnapshot
                
                guard let value = snap.value else {
                    return
                }
                let data = try! FirebaseDecoder().decode(Profile.self, from: value)
                
//                let snapshotValue = snap.value as! [String: String]
                
                self.narrowSearchedData(data)
            }
            if self.list.count == 0{
                print("ユーザーを見つけられませんでした！")
            }else{
                self.goToPreviousView()
            }
            
        })
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
        
        DispatchQueue.main.async {
            if self.teamTextField.text! != "" {
                self.searchFirebaseDatabase(child: "team", equelValue: self.teamTextField.text!)
                
            } else if self.regionTextField.text != "" {
                self.searchFirebaseDatabase(child: "region", equelValue: self.regionTextField.text!)
                
            } else if self.ageTextField.text != "" {
                self.searchFirebaseDatabase(child: "age", equelValue: self.ageTextField.text!)
                
            } else if self.genderTextField.text != "" {
                self.searchFirebaseDatabase(child: "gender", equelValue: self.genderTextField.text!)
            }
        }
    }
}
