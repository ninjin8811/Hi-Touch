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
import FirebaseFirestore
import SVProgressHUD
import UIKit
import AlamofireImage
import Nuke

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    var profileData = Profile()
//    var proDataRef = Database.database().reference()
    var db = Firestore.firestore()
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Settings to cache images
        // 1
        DataLoader.sharedUrlCache.diskCapacity = 0
        
        let pipeline = ImagePipeline {
            // 2
            let dataCache = try! DataCache(name: "com.hi-touch.datacache")
            // 3
            dataCache.sizeLimit = 200 * 1024 * 1024
            // 4
            $0.dataCache = dataCache
        }
        // 5
        ImagePipeline.shared = pipeline
        
        let contentMode = ImageLoadingOptions.ContentModes(success: .scaleAspectFill, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
        ImageLoadingOptions.shared.contentModes = contentMode
        ImageLoadingOptions.shared.placeholder = UIImage(named: "alien")
        ImageLoadingOptions.shared.failureImage = UIImage(named: "alien")
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.5)
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.imageViewTapped(_:))))
        
        nameTextField.text = profileData.name
        ageTextField.text = profileData.age
        teamTextField.text = profileData.team
        regionTextField.text = profileData.region
        genderTextField.text = profileData.gender
        
        loadAvatarImage()
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
        
        guard let uid = userID else {
            preconditionFailure("ユーザーIDが渡されてませんでした！")
        }
        
        let profileDictionary: [String: Any] = ["gender": gender, "name": name, "age": age, "team": team, "region": region, "userID": uid, "imageURL": profileData.imageURL]
        
        db.collection("users").document(uid).setData(profileDictionary) { (error) in
            if error != nil {
                print("セーブできませんでした！")
            } else {
                print("セーブできました！")
            }
        }
    }
    
    func uploadImage(_ resizedImage: UIImage) {
        SVProgressHUD.show()
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let imageRef = Storage.storage().reference().child("avatarImages").child("\(userID).jpg")
        
        if let data = resizedImage.jpegData(compressionQuality: 1.0) {
            imageRef.putData(data, metadata: nil) { _, error in
                
                if error != nil {
                    print("画像をアップロードできませんでした！")
                } else {
                    print("画像がアップロードされました！")
                    
                    imageRef.downloadURL(completion: { uploadedImageURL, error in
                        
                        if error != nil {
                            print("ダウンロードURLが取得できませんでした！")
                        } else {
                            guard let imageURL = uploadedImageURL?.absoluteString else {
                                return
                            }
                            self.profileData.imageURL = imageURL
                            self.loadAvatarImage()
                        }
                    })
                }
            }
        }
        SVProgressHUD.dismiss()
    }
    
    func loadAvatarImage() {
        if profileData.imageURL != "default" {
            guard let downloadURL = URL(string: profileData.imageURL) else{
                preconditionFailure("StringからURLに変換できませんでした！")
            }
            let request = ImageRequest(url: downloadURL, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill)
            Nuke.loadImage(with: request, into: profileImageView)
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        let resizedImage = resizeImage(image: image, width: 480)
        
        //resizedImageは丸画像になってない！！
        //丸画像にする処理を書く
        uploadImage(resizedImage)
        
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
