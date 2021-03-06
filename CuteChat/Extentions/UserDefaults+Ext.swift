//
//  UserDefaults+Ext.swift
//  CuteChat
//
//  Created by Антон on 08.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

extension UserDefaults {
    
  func colorForKey(key: String) -> UIColor? {
    var colorReturnded: UIColor?
    if let colorData = data(forKey: key) {
      do {
        if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
          colorReturnded = color
        }
      } catch {
        print("Could not set UIColor from Data with key \"color\"")
      }
    }
    return colorReturnded
  }
  
  func setColor(color: UIColor?, forKey key: String) {
    var colorData: NSData?
    if let color = color {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
        colorData = data
      } catch {
        print("Could not convert UIColor to Data with key \"color\"")
      }
    }
    set(colorData, forKey: key)
  }
}
