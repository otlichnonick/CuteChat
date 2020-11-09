//
//  Date+Ext.swift
//  CuteChat
//
//  Created by Антон on 05.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

extension Date {
    
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        return dateFormatter.string(from: self)
    }
}
