//
//  DateUtils.swift
//  Abacus
//
//  Created by AyunaLabs on 29/11/21.
//

import Foundation
func getTimeStampDateString() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "dd.MM.yyyy"
    let strDate = dateFormatter.string(from: date)
    return strDate
}


func getTimeStampDateStringForAsKey() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let strDate = dateFormatter.string(from: date)
    return strDate
}
