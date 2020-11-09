//
//  UIHelper.swift
//  CuteChat
//
//  Created by Антон on 09.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

enum UIHelper {
    
    static func addImageView(on superView: UIView) -> UIImageView {
        let imageView = UIImageView()
        superView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.pinToEdges(on: superView)
        imageView.layer.cornerRadius   = 8
        imageView.clipsToBounds  = true
        return imageView
    }
    
    static func addLabel(on superView: UIView) -> UILabel {
        let label = UILabel()
        superView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.pinToEdges(on: superView)
        label.layer.cornerRadius   = 8
        label.layer.masksToBounds  = true
        return label
    }
}
