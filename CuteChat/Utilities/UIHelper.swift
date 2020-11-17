//
//  UIHelper.swift
//  CuteChat
//
//  Created by Антон on 09.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit
import Firebase

enum UIHelper {
    
    static func addImageView(on superView: UIView) -> UIImageView {
        let imageView = UIImageView()
        superView.addSubview(imageView)
        imageView.pinToEdges(on: superView)
        imageView.layer.cornerRadius   = 8
        imageView.clipsToBounds  = true
        
        return imageView
    }
    
    static func addAvatarLabel(on superView: UIView, fontSize: CGFloat) {
        let label = UILabel()
        superView.addSubview(label)
        label.pinToEdges(on: superView)
        label.layer.cornerRadius   = 8
        label.layer.masksToBounds  = true
        label.text = Auth.auth().currentUser?.email?.prefix(2).uppercased()
        label.backgroundColor = UserDefaults.standard.colorForKey(key: "color")
        label.font = .systemFont(ofSize: fontSize)
    }
    
    static func addAvatarImage(on superView: UIView) {
        let avatarImageView = addImageView(on: superView)
        FirebaseManager.shared.getPhoto(from: (Auth.auth().currentUser?.photoURL)!) { (image) in
            DispatchQueue.main.async {
                avatarImageView.image = image
            }
        }
    }
    
    static func checkUsername(with name: String) -> Bool {
        if !name.isEmpty,
            name.first!.isUppercase,
            name.isCyrillic {
            return true
        } else {
            return false
        }
    }
}
