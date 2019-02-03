//
//  Profile.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/04.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import Foundation
import RealmSwift

class Profile: Object{
    
    @objc dynamic var userID: String?
    @objc dynamic var name: String = "吉野 史也"
    @objc dynamic var team: String = "Liverpool"
    @objc dynamic var age: Int = 22
    @objc dynamic var region: String = "Osaka"
}
