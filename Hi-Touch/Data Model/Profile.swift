//
//  Profile.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/04.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import Foundation
import CodableFirebase

class Profile: Decodable {
    var gender: String = "Gender"
    var name: String = "Name"
    var team: String = "Liverpool"
    var age: String = "Age"
    var region: String = "Region"
    var userID: String = "default"
    var imageURL: String = "default"
}
