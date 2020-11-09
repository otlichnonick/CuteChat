//
//  MessageCell.swift
//  CuteChat
//
//  Created by Антон on 04.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageBubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var leftUsernameLabel: UILabel!
    @IBOutlet weak var rightUsernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configure() {
        messageBubbleView.layer.cornerRadius    = messageBubbleView.frame.size.height / 4
        leftUsernameLabel.layer.cornerRadius    = 8
        rightUsernameLabel.layer.cornerRadius   = 8
        leftUsernameLabel.layer.masksToBounds   = true
        rightUsernameLabel.layer.masksToBounds  = true
    }
    
    func setupCell(with message: Message) {
        messageLabel.text       = message.body
        dateLabel.text          = message.date
        leftUsernameLabel.text  = message.sender.prefix(3).capitalized
        rightUsernameLabel.text = message.sender.prefix(3).capitalized
    }
    
}
