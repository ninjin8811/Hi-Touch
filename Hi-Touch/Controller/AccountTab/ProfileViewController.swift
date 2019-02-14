//
//  ProfileViewController.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/06.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import CodableFirebase
import Firebase
import FirebaseStorage
import SVProgressHUD
import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    var profileData = Profile()
    var proDataRef = Database.database().reference()
    var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.imageViewTapped(_:))))
        
        nameTextField.text = profileData.name
        ageTextField.text = profileData.age
        teamTextField.text = profileData.team
        regionTextField.text = profileData.region
        genderTextField.text = profileData.gender
        
        if let image = avatarImage{
            profileImageView.image = image
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        pickImage()
    }
    
    func checkEmpty(checkValue: String) -> String {
        if checkValue != "" {
            return checkValue
        } else {
            let alert = UIAlertController(title: "エラー", message: "全て入力してください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            return ""
        }
    }
    
    /*-----------------------------------------------------------------------------------------*/
    
    // MARK: - Data Manipulate Methods
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let name = checkEmpty(checkValue: nameTextField.text!)
        let age = checkEmpty(checkValue: ageTextField.text!)
        let team = checkEmpty(checkValue: teamTextField.text!)
        let region = checkEmpty(checkValue: regionTextField.text!)
        let gender = checkEmpty(checkValue: genderTextField.text!)
        
        let profileDictionary = ["gender": gender, "name": name, "age": age, "team": team, "region": region, "userID": Auth.auth().currentUser?.uid, "imageURL": profileData.imageURL]
        
        proDataRef.setValue(profileDictionary) { error, _ in
            
            if error != nil {
                print("セーブできませんでした！")
            } else {
                print("セーブできました！")
            }
        }
    }
    
    func uploadImage(image: UIImage) {
        SVProgressHUD.show()
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let imageRef = Storage.storage().reference().child("avatarImages").child("\(userID).jpg")
        
        if let data = UIImageJPEGRepresentation(profileImageView.image!, 1.0) {
            imageRef.putData(data, metadata: nil) { _, error in
                
                if error != nil {
                    print("画像をアップロードできませんでした！")
                } else {
                    print("画像がアップロードされました！")
                    
                    imageRef.downloadURL(completion: { url, error in
                        
                        if error != nil {
                            print("ダウンロードURLが取得できませんでした！")
                        } else {
                            guard let imageURL = url?.absoluteString else {
                                return
                            }
                            self.profileData.imageURL = imageURL
                        }
                    })
                }
            }
        }
        SVProgressHUD.dismiss()
    }
}

/*-----------------------------------------------------------------------------------------*/

// MARK: - Select Profile Image Method

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        print("画像がタップされました！")
        pickImage()
    }
    
    func pickImage() {
        let pickerView = UIImagePickerController()
        
        let alert = UIAlertController(title: "プロフィール画像を選んでください", message: "", preferredStyle: .actionSheet)
        let launchCameraAction = UIAlertAction(title: "カメラを起動", style: .default) { _ in
            
            pickerView.sourceType = .camera
            self.present(pickerView, animated: true, completion: nil)
        }
        let pickAction = UIAlertAction(title: "カメラロールから選択", style: .default) { _ in
            
            pickerView.sourceType = .photoLibrary
            self.present(pickerView, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alert.addAction(launchCameraAction)
        alert.addAction(pickAction)
        alert.addAction(cancelAction)
        
        pickerView.allowsEditing = true
        pickerView.delegate = self
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let resizedImage = resizeImage(image: image, width: 480)
        
        profileImageView.image = resizedImage.af_imageRoundedIntoCircle()
        
        uploadImage(image: resizedImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, width: Double) -> UIImage {
        let aspectStyle = image.size.height / image.size.width
        
        let resizedSize = CGSize(width: width, height: width * Double(aspectStyle))
        
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
}
