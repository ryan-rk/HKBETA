//
//  UserSettings.swift
//  BETA
//
//  Created by Ryan RK on 5/11/2021.
//

import Foundation

struct UserSettings {
    
    static let appGroupUrl = "group.com.rkcoding.ios.BETA.contents"
    
    static var selectedLanguage: Language = .EN
    
    enum Language {
        case EN
        case TC
        case SC
    }
}
