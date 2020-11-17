//
//  UIColor+Ext.swift
//  CuteChat
//
//  Created by Антон on 05.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

extension UIColor {
    
    func getRandomColor() -> UIColor {
         let red:CGFloat    = CGFloat(drand48())
         let green:CGFloat  = CGFloat(drand48())
         let blue:CGFloat   = CGFloat(drand48())

         return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
}
