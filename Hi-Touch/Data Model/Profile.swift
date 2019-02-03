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
    
    @objc dynamic var autoID: String?
    @objc dynamic var firstName: String = "史也"
    @objc dynamic var lastName: String = "吉野"
    @objc dynamic var team: String = "Liverpool"
    @objc dynamic var age: Int = 22
}
