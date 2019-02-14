//
//  ChatUserCell.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/12.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit

class ChatUserCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
