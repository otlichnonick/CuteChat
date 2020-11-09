//
//  String+Ext.swift
//  CuteChat
//
//  Created by Антон on 06.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

extension String {
    
    var isLatin: Bool {
        let upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let lower = "abcdefghijklmnopqrstuvwxyz"
        for c in self.map({String($0)}) where !upper.contains(c) && !lower.contains(c) {
            return false
        }
        return true
    }
    
    var isCyrillic: Bool {
        let upper = "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЮЯ"
        let lower = "абвгдежзийклмнопрстуфхцчшщьюя"
        for c in self.map({String($0)}) where !upper.contains(c) && !lower.contains(c) {
            return false
        }
        return true
    }
}
