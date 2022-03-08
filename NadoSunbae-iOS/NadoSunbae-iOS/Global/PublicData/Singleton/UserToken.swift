//
//  UserToken.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/03/09.
//

import Foundation

class UserToken {
    
    /// 유저 토큰 관리를 위한 싱글톤 객체 선언
    static let shared = UserToken()
    
    var accessToken: String?
    var refreshToken: String?
    
    private init() { }
}
