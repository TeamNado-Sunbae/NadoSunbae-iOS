//
//  UserDefaults+.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import Foundation

extension UserDefaults {
    
    /// UserDefaults key value가 많아지면 관리하기 어려워지므로 enum 'Keys'로 묶어 관리합니다.
    enum Keys {
        
        /// String
        static var FCMTokenForDevice = "FCMTokenForDevice"
        
        /// String
        static var AccessToken = "AccessToken"
        
        /// String
        static var RefreshToken = "RefreshToken"
        
        /// Int
        static var FirstMajorID = "MajorID"
        
        /// String
        static var FirstMajorName = "MajorName"
        
        /// Int
        static var SecondMajorID = "SecondMajorID"
        
        /// String
        static var SecondMajorName = "SecondMajorName"
        
        /// Int
        static var UserID = "userID"
        
        /// Bool
        static var IsReviewed = "IsReviewed"
        
        /// Int
        static var SelectedMajorID = "SelectedMajorID"
        
        /// String
        static var SelectedMajorName = "SelectedMajorName"
        
        /// String
        static var Email = "Email"
        
        /// String
        static var PW = "PW"
    }
}
