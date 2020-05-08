//
//  Utils.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Foundation

struct Utils {
    
    static let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        #if os(watchOS)
        formatter.unitsStyle = .short
        #else
        formatter.unitsStyle = .full
        #endif
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        #if os(watchOS)
        formatter.dateFormat = "dd/MM"
        #else
        formatter.dateFormat = "dd/MM/yyyy"
        #endif
        return formatter
    }()
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.isLenient = true
        formatter.numberStyle = .currency
        return formatter
    }()
    
}
