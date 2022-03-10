//
//  UserPermissionInfo.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/03/10.
//

import Foundation

class UserPermissionInfo {
    
    /// 유저 권한 관리를 위한 싱글톤 객체 선언
    static let shared = UserPermissionInfo()
    
    var isReviewed = false
    var isUserReported = false
    var isReviewInappropriate = false
    var permissionMsg = ""
    
    private init() { }
}
