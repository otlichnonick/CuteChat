//
//  PersistenceManager.swift
//  CuteChat
//
//  Created by Антон on 09.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation
import Firebase

class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    private var defaults = UserDefaults.standard
    
    func saveUserInfo(with authResult: AuthDataResult) {
        let userID = authResult.user.uid
        defaults.set(userID, forKey: "userID")
        let avatarUserColor = UIColor().getRandomColor()
        defaults.setColor(color: avatarUserColor, forKey: "color")
    }
}
