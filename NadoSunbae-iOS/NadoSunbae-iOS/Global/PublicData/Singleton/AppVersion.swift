//
//  AppVersion.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/03/09.
//

import Foundation

class AppVersion {
    
    /// 앱 버전 관리를 위한 싱글톤 객체 선언
    static let shared = AppVersion()
    
    var latestVersion = ""
    var currentVersion = "1.0.0"
    
    private init() { }
}
