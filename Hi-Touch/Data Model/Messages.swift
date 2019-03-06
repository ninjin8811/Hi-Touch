//
//  Messages.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/13.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import Foundation
import RealmSwift

class Messages: Object {
    @objc dynamic var message: String?
    @objc dynamic var timeCreated: Date?
    
    var parentUser = LinkingObjects(fromType: ChatUser.self, property: "messages")
}
