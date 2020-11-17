//
//  Double+Ext.swift
//  CuteChat
//
//  Created by Антон on 06.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

extension Double {

func convertDateFromWebToApp() -> String {
        let date                = Date(timeIntervalSince1970: self)
        let dateFormatter       = DateFormatter()
        dateFormatter.locale    = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    
        return dateFormatter.string(from: date)
    }
}
