//
//  ChatUserProfile.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/13.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import Foundation
import RealmSwift

class ChatUserProfile: Object{
    @objc dynamic var name = "name"
    @objc dynamic var recentMessage = "message"
    @objc dynamic var time = "time"
    
    let messages = List<Messages>()
}
